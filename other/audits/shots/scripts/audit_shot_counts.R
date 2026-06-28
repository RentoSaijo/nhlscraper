#!/usr/bin/env Rscript

# Shot Count Audit ---------------------------------------------------------

# Load libraries.
suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(xml2)
  library(httr2)
})

# Define helpers.
`%||%` <- function(x, y) if (is.null(x)) y else x

# Resolve paths.
args <- commandArgs(FALSE)
cmd_file <- sub(
  '^--file=',
  '',
  args[grepl('^--file=', args)][1] %||% ''
)
script_dir <- if (nzchar(cmd_file)) dirname(normalizePath(cmd_file)) else getwd()
root <- normalizePath(file.path(script_dir, '../../..'), mustWork = FALSE)
if (!file.exists(file.path(root, 'DESCRIPTION'))) root <- getwd()
setwd(root)

# Source package files.
source('R/Utility.R')
source('R/Game.R')
source('R/Load.R')
source('R/Team.R')
source('R/Skater.R')

# Define output paths.
audit_dir <- file.path(root, 'other/audits/shots')
data_dir <- file.path(audit_dir, 'data')
out_dir <- file.path(audit_dir, 'outputs')
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# Define shot types.
shot_types <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')

# Count attempts.
.count_attempts <- function(x) {
  g <- sum(x$eventTypeDescKey == 'goal', na.rm = TRUE)
  saved <- sum(x$eventTypeDescKey == 'shot-on-goal', na.rm = TRUE)
  missed <- sum(x$eventTypeDescKey == 'missed-shot', na.rm = TRUE)
  blocked <- sum(x$eventTypeDescKey == 'blocked-shot', na.rm = TRUE)
  tibble::tibble(
    rows = nrow(x),
    G = g,
    saved = saved,
    iSF = g + saved,
    missed = missed,
    iFF = g + saved + missed,
    blocked = blocked,
    iCF = g + saved + missed + blocked
  )
}

# Load play-by-plays.
pbp <- gc_play_by_plays(20252026)
regular_attempts <- pbp |>
  dplyr::filter(gameTypeId == 2, eventTypeDescKey %in% shot_types)

# Write regular-season game IDs.
write.csv(
  pbp |>
    dplyr::filter(gameTypeId == 2) |>
    dplyr::distinct(gameId) |>
    dplyr::arrange(gameId),
  file.path(out_dir, 'regular_game_ids.csv'),
  row.names = FALSE
)

# Summarize play-by-play filters.
pbp_filters <- dplyr::bind_rows(
  strength_even = regular_attempts |>
    dplyr::filter(strengthState == 'even-strength') |>
    .count_attempts(),
  skater_5v5 = regular_attempts |>
    dplyr::filter(skaterCountFor == 5, skaterCountAgainst == 5) |>
    .count_attempts(),
  code_1551 = regular_attempts |> dplyr::filter(situationCode == '1551') |> .count_attempts(),
  code_1551_no_empty = regular_attempts |>
    dplyr::filter(situationCode == '1551', !isEmptyNetFor, !isEmptyNetAgainst) |>
    .count_attempts(),
  .id = 'source'
)
write.csv(pbp_filters, file.path(out_dir, 'pbp_filter_totals.csv'), row.names = FALSE)

# Filter 5v5 play-by-plays.
pbp_1551 <- regular_attempts |>
  dplyr::filter(situationCode == '1551', !isEmptyNetFor, !isEmptyNetAgainst)

# Compare site totals.
site_totals <- list(
  EvolvingHockey = readxl::read_excel(file.path(data_dir, 'EvolvingHockey.xlsx')) |>
    dplyr::summarise(
      rows = dplyr::n(),
      G = sum(G, na.rm = TRUE),
      saved = sum(iSF, na.rm = TRUE) - sum(G, na.rm = TRUE),
      iSF = sum(iSF, na.rm = TRUE),
      missed = sum(iFF, na.rm = TRUE) - sum(iSF, na.rm = TRUE),
      iFF = sum(iFF, na.rm = TRUE),
      blocked = sum(iCF, na.rm = TRUE) - sum(iFF, na.rm = TRUE),
      iCF = sum(iCF, na.rm = TRUE)
    ),
  NaturalStatTrick = read.csv(file.path(data_dir, 'NaturalStatTrick.csv'), check.names = TRUE) |>
    dplyr::summarise(
      rows = dplyr::n(),
      G = sum(Goals, na.rm = TRUE),
      saved = sum(Shots, na.rm = TRUE) - sum(Goals, na.rm = TRUE),
      iSF = sum(Shots, na.rm = TRUE),
      missed = sum(iFF, na.rm = TRUE) - sum(Shots, na.rm = TRUE),
      iFF = sum(iFF, na.rm = TRUE),
      blocked = sum(iCF, na.rm = TRUE) - sum(iFF, na.rm = TRUE),
      iCF = sum(iCF, na.rm = TRUE)
    ),
  HockeyStats = read.csv(file.path(data_dir, 'HockeyStats.csv'), check.names = TRUE) |>
    dplyr::summarise(
      rows = dplyr::n(),
      G = sum(G, na.rm = TRUE),
      saved = sum(iSF, na.rm = TRUE) - sum(G, na.rm = TRUE),
      iSF = sum(iSF, na.rm = TRUE),
      missed = sum(iFF, na.rm = TRUE) - sum(iSF, na.rm = TRUE),
      iFF = sum(iFF, na.rm = TRUE),
      blocked = NA_integer_,
      iCF = NA_integer_
    ),
  nhlscraper_1551 = .count_attempts(pbp_1551)
) |>
  dplyr::bind_rows(.id = 'source')
write.csv(site_totals, file.path(out_dir, 'site_total_comparison.csv'), row.names = FALSE)

# Summarize 5v5 reasons.
reason_totals <- pbp_1551 |>
  dplyr::mutate(reason = ifelse(is.na(reason), '<NA>', reason)) |>
  dplyr::count(eventTypeDescKey, reason, name = 'n') |>
  dplyr::arrange(eventTypeDescKey, dplyr::desc(n), reason)
write.csv(reason_totals, file.path(out_dir, 'pbp_1551_reason_totals.csv'), row.names = FALSE)

# Summarize official team report.
official_team <- team_season_report(20252026, 2, 'summaryshooting')
official_team_summary <- official_team |>
  dplyr::summarise(
    source = 'NHL official team summaryshooting',
    shots5v5 = sum(shots5v5, na.rm = TRUE),
    usatFor = sum(usatFor, na.rm = TRUE),
    satFor = sum(satFor, na.rm = TRUE),
    usatTotal = sum(usatTotal, na.rm = TRUE),
    satTotal = sum(satTotal, na.rm = TRUE)
  )
write.csv(
  official_team_summary,
  file.path(out_dir, 'official_team_summaryshooting_totals.csv'),
  row.names = FALSE
)

# Parse on-ice counts.
.parse_on_ice_counts <- function(text) {
  txt <- gsub('\u00A0', ' ', as.character(text), fixed = TRUE)
  txt <- gsub('\\s+', ' ', txt)
  txt <- trimws(txt)
  if (!nzchar(txt)) {
    return(c(goalie = 0L, skaters = 0L))
  }
  tokens <- regmatches(txt, gregexpr('([0-9]{1,2})\\s+([A-Z]{1,3})', txt, perl = TRUE))[[1]]
  if (!length(tokens)) {
    return(c(goalie = 0L, skaters = 0L))
  }
  pos <- sub('^[0-9]{1,2}\\s+', '', tokens)
  c(goalie = as.integer(any(pos == 'G')), skaters = as.integer(sum(pos != 'G')))
}

# Parse HTML attempt counts.
.parse_html_attempt_counts <- function(game_id, home_id, away_id, home_abbrev, away_abbrev) {
  url <- .html_pbp_report_url(game_id)
  doc <- tryCatch(
    {
      resp <- httr2::request(url) |>
        httr2::req_timeout(20) |>
        httr2::req_perform()
      xml2::read_html(httr2::resp_body_string(resp))
    },
    error = function(e) NULL
  )
  if (is.null(doc)) {
    return(tibble::tibble(
      gameId = game_id,
      eventTypeDescKey = NA_character_,
      n = NA_integer_,
      fetched = FALSE
    ))
  }
  rows <- xml2::xml_find_all(doc, './/tr')
  out <- vector('list', length(rows))
  n_out <- 0L
  for (row in rows) {
    cells <- xml2::xml_find_all(row, './th|./td')
    if (length(cells) < 8L) next
    txt <- xml2::xml_text(cells, trim = TRUE)
    txt <- gsub('\u00A0', ' ', txt, fixed = TRUE)
    txt <- trimws(txt)
    if (!length(txt) || !grepl('^[0-9]+$', txt[1])) next
    type <- .html_event_code_to_type_desc(txt[5], txt[6])
    if (!type %in% shot_types) next
    away_counts <- .parse_on_ice_counts(txt[length(txt) - 1L])
    home_counts <- .parse_on_ice_counts(txt[length(txt)])
    is_5v5 <- away_counts[['goalie']] == 1L &&
      home_counts[['goalie']] == 1L &&
      away_counts[['skaters']] == 5L &&
      home_counts[['skaters']] == 5L
    if (!is_5v5) next
    n_out <- n_out + 1L
    out[[n_out]] <- tibble::tibble(
      gameId = game_id,
      period = .parse_html_period_label(txt[2]),
      secondsElapsedInPeriod = .parse_html_elapsed_clock(txt[4]),
      htmlEventNumber = suppressWarnings(as.integer(txt[1])),
      htmlEventCode = trimws(toupper(txt[5])),
      eventTypeDescKey = type,
      description = txt[6],
      ownerTeamId = .html_desc_owner_team_id(
        txt[6],
        home_abbrev = home_abbrev,
        away_abbrev = away_abbrev,
        home_team_id = home_id,
        away_team_id = away_id
      ),
      fetched = TRUE
    )
  }
  if (!n_out) {
    return(tibble::tibble(
      gameId = game_id,
      eventTypeDescKey = character(),
      n = integer(),
      fetched = TRUE
    ))
  }
  dplyr::bind_rows(out[seq_len(n_out)])
}

# Resolve HTML events.
html_events_file <- file.path(out_dir, 'nhl_html_5v5_attempt_events.csv')
run_r_html <- identical(Sys.getenv('RUN_SLOW_R_HTML'), '1')
if (run_r_html && !file.exists(html_events_file)) {
  team_lookup <- teams() |> dplyr::select(teamId, teamTriCode)
  game_sides <- pbp |>
    dplyr::filter(gameTypeId == 2, !is.na(eventOwnerTeamId), !is.na(isHome)) |>
    dplyr::group_by(gameId) |>
    dplyr::summarise(
      homeId = dplyr::first(eventOwnerTeamId[isHome]),
      awayId = dplyr::first(eventOwnerTeamId[!isHome]),
      .groups = 'drop'
    ) |>
    dplyr::left_join(team_lookup, by = c('homeId' = 'teamId')) |>
    dplyr::rename(homeAbbrev = teamTriCode) |>
    dplyr::left_join(team_lookup, by = c('awayId' = 'teamId')) |>
    dplyr::rename(awayAbbrev = teamTriCode) |>
    dplyr::arrange(gameId)
  workers <- min(8L, max(1L, parallel::detectCores(logical = TRUE) - 1L))
  message('Fetching ', nrow(game_sides), ' NHL HTML reports with ', workers, ' workers')
  html_events <- parallel::mclapply(seq_len(nrow(game_sides)), function(i) {
    .parse_html_attempt_counts(
      game_id = game_sides$gameId[i],
      home_id = game_sides$homeId[i],
      away_id = game_sides$awayId[i],
      home_abbrev = game_sides$homeAbbrev[i],
      away_abbrev = game_sides$awayAbbrev[i]
    )
  }, mc.cores = workers, mc.preschedule = FALSE) |>
    dplyr::bind_rows()
  write.csv(html_events, html_events_file, row.names = FALSE)
} else if (run_r_html && file.exists(html_events_file)) {
  html_events <- read.csv(html_events_file, check.names = FALSE)
  # Summarize HTML totals.
  html_totals <- html_events |>
    dplyr::count(eventTypeDescKey, name = 'n') |>
    dplyr::mutate(
      G = ifelse(eventTypeDescKey == 'goal', n, 0L),
      saved = ifelse(eventTypeDescKey == 'shot-on-goal', n, 0L),
      missed = ifelse(eventTypeDescKey == 'missed-shot', n, 0L),
      blocked = ifelse(eventTypeDescKey == 'blocked-shot', n, 0L)
    ) |>
    dplyr::summarise(
      source = 'NHL HTML PL 5v5 by on-ice counts',
      rows = sum(n),
      G = sum(G),
      saved = sum(saved),
      iSF = sum(G) + sum(saved),
      missed = sum(missed),
      iFF = sum(G) + sum(saved) + sum(missed),
      blocked = sum(blocked),
      iCF = sum(G) + sum(saved) + sum(missed) + sum(blocked)
    )
  write.csv(html_totals, file.path(out_dir, 'nhl_html_5v5_totals.csv'), row.names = FALSE)
} else {
  message('Skipping slow R HTML parser. Run scripts/fetch_html_5v5_counts.py for HTML PL counts.')
}

message('Wrote audit outputs to: ', out_dir)
