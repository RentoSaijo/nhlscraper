#' Access the GameCenter (GC) play-by-plays for a season
#' 
#' `gc_play_by_plays()` loads the GC play-by-plays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{gc_pbps_20212022 <- gc_play_by_plays(season = 20212022)}
#' @export

gc_play_by_plays <- function(season = 20242025) {
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/game/pbps/gc/NHL_PBPS_GC_',
        season,
        '.csv.gz'
      )
      tmp <- tempfile(fileext = '.csv.gz')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE)
      con <- gzfile(tmp, open = 'rt')
      on.exit(close(con), add = TRUE)
      pbps <- utils::read.csv(con)
      raw_situation <- pbps[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid         <- !is.na(situation_chr) & nchar(situation_chr) > 0
      if (any(valid)) {
        situation_pad[valid] <- sprintf('%04d', as.integer(situation_chr[valid]))
      }
      pbps[['situationCode']] <- situation_pad
      pbps
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname gc_play_by_plays
#' @export
gc_pbps <- function(season = 20242025) {
  gc_play_by_plays(season)
}

#' Access the World Showcase (WSC) play-by-plays for a season
#' 
#' `wsc_play_by_plays()` loads the WSC play-by-plays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{wsc_pbps_20212022 <- wsc_play_by_plays(season = 20212022)}
#' @export

wsc_play_by_plays <- function(season = 20242025) {
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/game/pbps/wsc/NHL_PBPS_WSC_',
        season,
        '.csv.gz'
      )
      tmp <- tempfile(fileext = '.csv.gz')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE)
      con <- gzfile(tmp, open = 'rt')
      on.exit(close(con), add = TRUE)
      pbps <- utils::read.csv(con)
      raw_situation <- pbps[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid         <- !is.na(situation_chr) & nchar(situation_chr) > 0
      if (any(valid)) {
        situation_pad[valid] <- sprintf('%04d', as.integer(situation_chr[valid]))
      }
      pbps[['situationCode']] <- situation_pad
      pbps
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname wsc_play_by_plays
#' @export
wsc_pbps <- function(season = 20242025) {
  wsc_play_by_plays(season)
}

#' Access the shift charts for a season
#' 
#' `shift_charts()` loads the shift charts for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{shift_charts_20212022 <- shift_charts(season = 20212022)}
#' @export

shift_charts <- function(season = 20242025) {
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/game/scs/NHL_SCS_',
        season,
        '.csv.gz'
      )
      tmp <- tempfile(fileext = '.csv.gz')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE)
      con <- gzfile(tmp, open = 'rt')
      on.exit(close(con), add = TRUE)
      utils::read.csv(con)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
