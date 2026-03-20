# Load libraries.
suppressMessages(library(tidyverse))
suppressMessages(library(nhlscraper))
suppressMessages(library(httr2))
suppressMessages(library(jsonlite))

# Define helpers.
format_elapsed_seconds <- function(start_time) {
  sprintf('%.1fs', proc.time()[['elapsed']] - start_time)
}
get_column_type_bucket <- function(x) {
  if (inherits(x, 'POSIXct')) {
    return('datetime')
  }
  if (inherits(x, 'Date')) {
    return('date')
  }
  if (is.factor(x)) {
    return('character')
  }
  if (is.character(x)) {
    return('character')
  }
  if (is.integer(x)) {
    return('integer')
  }
  if (is.double(x)) {
    return('double')
  }
  if (is.logical(x)) {
    return('logical')
  }
  if (is.list(x)) {
    return('list')
  }

  class(x)[1]
}
get_typed_na_vector <- function(target_type, n) {
  switch(
    target_type,
    character = rep(NA_character_, n),
    double = rep(NA_real_, n),
    integer = rep(NA_integer_, n),
    logical = rep(NA, n),
    date = as.Date(rep(NA_character_, n)),
    datetime = as.POSIXct(rep(NA_character_, n), tz = 'UTC'),
    list = vector('list', n),
    rep(NA_character_, n)
  )
}
choose_common_column_type <- function(column_vectors) {
  non_missing_vectors <- purrr::keep(column_vectors, ~length(.x) > 0L && !all(is.na(.x)))
  non_missing_types <- unique(vapply(non_missing_vectors, get_column_type_bucket, character(1)))

  if (!length(non_missing_types)) {
    all_types <- unique(vapply(column_vectors, get_column_type_bucket, character(1)))
    if (all(all_types %in% c('double', 'integer', 'logical'))) {
      return('double')
    }
    if (length(all_types) == 1L) {
      return(all_types[[1]])
    }
    return('character')
  }

  if (all(non_missing_types %in% c('double', 'integer', 'logical'))) {
    if (identical(non_missing_types, 'logical')) {
      return('logical')
    }
    if ('double' %in% non_missing_types || 'logical' %in% non_missing_types) {
      return('double')
    }
    return('integer')
  }

  if (length(non_missing_types) == 1L) {
    return(non_missing_types[[1]])
  }

  'character'
}
coerce_column_to_type <- function(x, target_type) {
  if (all(is.na(x))) {
    return(get_typed_na_vector(target_type, length(x)))
  }

  switch(
    target_type,
    character = as.character(x),
    double = as.double(x),
    integer = as.integer(x),
    logical = as.logical(x),
    date = as.Date(x),
    datetime = as.POSIXct(x, tz = 'UTC'),
    list = as.list(x),
    as.character(x)
  )
}
normalize_result_column_types <- function(results, progress_label) {
  results <- purrr::map(results, ~{
    if (is.null(.x)) {
      data.frame()
    } else {
      as.data.frame(.x, stringsAsFactors = FALSE)
    }
  })

  all_columns <- results %>%
    purrr::map(names) %>%
    unlist(use.names = FALSE) %>%
    unique()

  mixed_columns <- character()
  sparse_columns <- character()
  target_types <- setNames(vector('list', length(all_columns)), all_columns)
  for (column_name in all_columns) {
    column_vectors <- purrr::map(results, ~{
      if (column_name %in% names(.x)) .x[[column_name]] else NULL
    })
    present_vectors <- purrr::compact(column_vectors)

    if (!length(present_vectors)) {
      next
    }

    source_types <- unique(vapply(present_vectors, get_column_type_bucket, character(1)))
    target_type <- choose_common_column_type(present_vectors)
    target_types[[column_name]] <- target_type
    if (length(source_types) > 1L) {
      mixed_columns <- c(mixed_columns, column_name)
    }
    if (any(vapply(column_vectors, is.null, logical(1)))) {
      sparse_columns <- c(sparse_columns, column_name)
    }
  }

  results <- purrr::map(results, ~{
    for (column_name in all_columns) {
      target_type <- target_types[[column_name]]
      if (is.null(target_type)) {
        next
      }

      if (!column_name %in% names(.x)) {
        .x[[column_name]] <- get_typed_na_vector(target_type, nrow(.x))
      } else {
        .x[[column_name]] <- coerce_column_to_type(.x[[column_name]], target_type)
      }
    }
    .x[all_columns]
  })

  if (length(mixed_columns)) {
    message(sprintf(
      '%s: normalized mixed-type columns before binding: %s',
      progress_label,
      paste(sort(unique(mixed_columns)), collapse = ', ')
    ))
  }
  if (length(sparse_columns)) {
    message(sprintf(
      '%s: filled missing columns before binding: %s',
      progress_label,
      paste(sort(unique(sparse_columns)), collapse = ', ')
    ))
  }

  results
}
read_existing_game_csv <- function(file_path, progress_label) {
  if (!file.exists(file_path)) {
    return(NULL)
  }

  message(sprintf('%s: loading existing CSV %s.', progress_label, file_path))
  readr::read_csv(
    file_path,
    show_col_types = FALSE,
    guess_max = Inf
  )
}
get_scraped_game_ids <- function(existing_data) {
  if (is.null(existing_data) || !nrow(existing_data) || !'gameId' %in% names(existing_data)) {
    return(character())
  }

  existing_data %>%
    dplyr::pull(gameId) %>%
    as.character() %>%
    unique()
}
sort_game_csv_rows <- function(game_data) {
  if (is.null(game_data) || !nrow(game_data)) {
    return(game_data)
  }

  sort_columns <- c(
    'gameId',
    'sortOrder',
    'eventId',
    'period',
    'timeInPeriod'
  )
  sort_columns <- intersect(sort_columns, names(game_data))
  if (!length(sort_columns)) {
    return(game_data)
  }

  game_data %>%
    dplyr::arrange(dplyr::across(dplyr::all_of(sort_columns)))
}
merge_game_csv_data <- function(existing_data, new_data, progress_label) {
  results <- list(existing_data, new_data) %>%
    purrr::compact()
  if (!length(results)) {
    return(tibble::tibble())
  }

  results <- normalize_result_column_types(results, sprintf('%s merge', progress_label))
  merged_data <- dplyr::bind_rows(results)
  sort_game_csv_rows(merged_data)
}
fetch_raw_wsc_play_by_play <- function(game) {
  url <- sprintf('https://api-web.nhle.com/v1/wsc/play-by-play/%s', as.integer(game))
  resp <- httr2::request(url) %>%
    httr2::req_headers(
      referer = 'https://www.nhl.com/',
      'user-agent' = 'Chrome/130.0.0.0'
    ) %>%
    httr2::req_retry(
      max_tries = 3,
      backoff = function(attempt) 2 ^ (attempt - 1)
    ) %>%
    httr2::req_perform()
  plays <- jsonlite::fromJSON(
    httr2::resp_body_string(resp, encoding = 'UTF-8'),
    simplifyVector = TRUE,
    flatten = TRUE
  )
  plays <- as.data.frame(plays, stringsAsFactors = FALSE)
  if (!nrow(plays)) {
    return(plays)
  }
  if ('id' %in% names(plays)) {
    plays$id <- NULL
  }
  plays$gameId <- as.integer(game)
  plays <- plays[, c('gameId', setdiff(names(plays), 'gameId'))]
  plays
}
aggregate_game_data <- function(games, fetch_fun, progress_label, progress_every = 100L) {
  game_ids <- games %>% dplyr::pull(gameId)
  results <- vector('list', length(game_ids))
  names(results) <- as.character(game_ids)

  for (i in seq_along(game_ids)) {
    game_id <- game_ids[[i]]
    results[[i]] <- tryCatch(
      fetch_fun(game_id),
      error = function(e) {
        message(sprintf('%s: game %s failed: %s', progress_label, game_id, conditionMessage(e)))
        data.frame()
      }
    )
    if (i %% progress_every == 0L || i == length(game_ids)) {
      message(sprintf('%s: %s/%s games complete.', progress_label, i, length(game_ids)))
    }
  }

  results <- normalize_result_column_types(results, progress_label)
  dplyr::bind_rows(results)
}
aggregate_wsc_pbps <- function(games, progress_label = 'WSC raw play-by-play') {
  aggregate_game_data(games, fetch_raw_wsc_play_by_play, progress_label = progress_label)
}
update_season_game_csv <- function(games, file_path, aggregate_fun, progress_label) {
  dir.create(dirname(file_path), recursive = TRUE, showWarnings = FALSE)
  existing_data <- read_existing_game_csv(file_path, progress_label)
  scraped_game_ids <- get_scraped_game_ids(existing_data)
  games_to_scrape <- games %>%
    dplyr::filter(!as.character(gameId) %in% scraped_game_ids)

  message(sprintf(
    '%s: %s existing games found, %s games remaining to scrape.',
    progress_label,
    length(scraped_game_ids),
    nrow(games_to_scrape)
  ))

  if (!nrow(games_to_scrape)) {
    message(sprintf('%s: no scraping needed for %s.', progress_label, file_path))
    return(invisible(existing_data))
  }

  new_data <- aggregate_fun(games_to_scrape, progress_label = progress_label)
  merged_data <- merge_game_csv_data(existing_data, new_data, progress_label)
  readr::write_csv(merged_data, file_path)

  invisible(merged_data)
}
get_target_games <- function(
  start_season = 19171918L,
  end_season = 20252026L,
  date_cutoff = as.Date('2026-03-15'),
  max_games_per_season = 0L
) {
  games <- nhlscraper::games() %>%
    dplyr::filter(seasonId >= start_season) %>%
    dplyr::filter(seasonId <= end_season) %>%
    dplyr::filter(gameTypeId %in% c(1L, 2L, 3L)) %>%
    dplyr::filter(gameStateId == 7L) %>%
    dplyr::mutate(gameDate = as.Date(gameDate)) %>%
    dplyr::filter(gameDate <= date_cutoff) %>%
    dplyr::arrange(seasonId, gameDate, gameId)

  if (!is.na(max_games_per_season) && max_games_per_season > 0L) {
    games <- games %>%
      dplyr::group_by(seasonId) %>%
      dplyr::slice_head(n = max_games_per_season) %>%
      dplyr::ungroup()
  }

  games
}

# Run scraper.
OUTPUT_DIR <- 'other/inconsistencies/pbps/wsc'
START_SEASON <- as.integer(Sys.getenv('START_SEASON', unset = '19171918'))
END_SEASON <- as.integer(Sys.getenv('END_SEASON', unset = '20252026'))
DATE_CUTOFF <- as.Date(Sys.getenv('DATE_CUTOFF', unset = '2026-03-15'))
MAX_GAMES_PER_SEASON <- as.integer(Sys.getenv('MAX_GAMES_PER_SEASON', unset = '0'))

NHL_GAMES <- get_target_games(
  start_season = START_SEASON,
  end_season = END_SEASON,
  date_cutoff = DATE_CUTOFF,
  max_games_per_season = MAX_GAMES_PER_SEASON
)
NHL_SEASONS <- sort(unique(NHL_GAMES$seasonId))

for (s in NHL_SEASONS) {
  games <- dplyr::filter(NHL_GAMES, seasonId == s)
  file_path <- file.path(OUTPUT_DIR, sprintf('wsc_pbps_%s.csv', s))
  season_start_time <- proc.time()[['elapsed']]
  message(sprintf('Fetching raw WSC play-by-play for %s (%s games).', s, nrow(games)))
  update_season_game_csv(
    games = games,
    file_path = file_path,
    aggregate_fun = aggregate_wsc_pbps,
    progress_label = sprintf('WSC raw play-by-play %s', s)
  )
  message(sprintf(
    'Finished raw WSC play-by-play for %s in %s.',
    s,
    format_elapsed_seconds(season_start_time)
  ))
}
