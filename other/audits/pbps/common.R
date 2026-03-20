options(stringsAsFactors = FALSE, scipen = 999)

empty_findings <- function() {
  data.frame(
    gameId = integer(),
    period = integer(),
    eventId = integer(),
    sortOrder = integer(),
    timeInPeriod = character(),
    typeDescKey = character(),
    reason = character(),
    stringsAsFactors = FALSE
  )
}

bind_findings <- function(findings) {
  findings <- Filter(function(x) is.data.frame(x) && nrow(x) > 0L, findings)
  if (!length(findings)) {
    return(empty_findings())
  }
  out <- do.call(rbind, findings)
  rownames(out) <- NULL
  out
}

make_finding <- function(
  game_id,
  period = NA_integer_,
  event_id = NA_integer_,
  sort_order = NA_integer_,
  time_in_period = NA_character_,
  type_desc_key = NA_character_,
  reason
) {
  data.frame(
    gameId = as.integer(game_id),
    period = as.integer(period),
    eventId = as.integer(event_id),
    sortOrder = as.integer(sort_order),
    timeInPeriod = ifelse(is.na(time_in_period), NA_character_, as.character(time_in_period)),
    typeDescKey = ifelse(is.na(type_desc_key), NA_character_, as.character(type_desc_key)),
    reason = as.character(reason),
    stringsAsFactors = FALSE
  )
}

find_repo_root <- function(start_dir) {
  cur <- normalizePath(start_dir, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(cur, "DESCRIPTION"))) {
      return(cur)
    }
    parent <- dirname(cur)
    if (identical(parent, cur)) {
      stop("Unable to locate repo root from ", start_dir, call. = FALSE)
    }
    cur <- parent
  }
}

parse_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- args[grepl("^--file=", args)]
  if (!length(file_arg)) {
    stop("This script must be run via Rscript.", call. = FALSE)
  }
  dirname(normalizePath(sub("^--file=", "", file_arg[[1]]), winslash = "/", mustWork = TRUE))
}

parse_season_args <- function(args, available_seasons) {
  available_seasons <- sort(unique(as.integer(available_seasons)))
  if (!length(available_seasons)) {
    stop("No source seasons were discovered.", call. = FALSE)
  }

  if (!length(args)) {
    return(available_seasons)
  }

  if (length(args) == 1L && tolower(args[[1]]) %in% c("all", "--all")) {
    return(available_seasons)
  }

  seasons <- suppressWarnings(as.integer(args))
  if (any(is.na(seasons))) {
    stop("Season arguments must be 8-digit integers like 20232024, or `all`.", call. = FALSE)
  }

  missing <- setdiff(seasons, available_seasons)
  if (length(missing)) {
    stop(
      "Requested season(s) not found in the source directory: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }

  sort(unique(seasons))
}

format_season_span <- function(seasons) {
  seasons <- sort(unique(as.integer(seasons)))
  if (!length(seasons)) {
    return("")
  }
  if (length(seasons) == 1L) {
    return(as.character(seasons[[1]]))
  }
  sprintf("%s through %s", seasons[[1]], seasons[[length(seasons)]])
}

audit_ruleset_for_season <- function(season) {
  if (season >= 19171918L && season <= 19261927L) {
    return(list(
      id = "rs_ot_20min_19171918_19261927",
      label = "Regular-season full-period OT era (1917-18 through 1926-27)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season ties can proceed to a single full OT period;",
        "there is no shootout; playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = 1200L,
      regularSeasonOtSkaters = 5L,
      regularSeasonMaxPeriods = 4L,
      hasShootout = FALSE,
      rule_sources = c(
        "https://www.nhl.com/news/this-date-in-nhl-history-november-10-283498080"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        paste(
          "Regular-season OT is treated as a single 20:00 OT period in this earliest slice.",
          "That exact OT length cutoff is an inference from the raw 1917-18 through 1926-27 rows,",
          "which repeatedly extend beyond 10:00 of period 4."
        ),
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        "No shootout is allowed in this era.",
        "No `situationCode` exists in this schema era, so manpower-state checks are skipped."
      )
    ))
  }

  if (season >= 19271928L && season <= 19421943L) {
    return(list(
      id = "rs_ot_10min_19271928_19421943",
      label = "Regular-season 10-minute OT era (1927-28 through 1942-43)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season ties can proceed to a single 10:00 OT period;",
        "there is no shootout; playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = 600L,
      regularSeasonOtSkaters = 5L,
      regularSeasonMaxPeriods = 4L,
      hasShootout = FALSE,
      rule_sources = c(
        "https://www.nhl.com/news/this-date-in-nhl-history-november-10-283498080"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        paste(
          "Regular-season OT is treated as a single 10:00 OT period in this era.",
          "The 1927-28 cutoff is an inference from the raw files, where regular-season period-4 clocks",
          "drop below 10:00 from 1927-28 onward and stay there through 1942-43."
        ),
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        "No shootout is allowed in this era.",
        "No `situationCode` exists in this schema era, so manpower-state checks are skipped."
      )
    ))
  }

  if (season >= 19431944L && season <= 19821983L) {
    return(list(
      id = "no_rs_ot_19431944_19821983",
      label = "No regular-season overtime era (1943-44 through 1982-83)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season games should end after 3 periods;",
        "there is no shootout; playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = NA_integer_,
      regularSeasonOtSkaters = NA_integer_,
      regularSeasonMaxPeriods = 3L,
      hasShootout = FALSE,
      rule_sources = c(
        "https://www.nhl.com/news/this-date-in-nhl-history-november-10-283498080"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        "Regular-season overtime is not legal in this era.",
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        "No shootout is allowed in this era.",
        "No `situationCode` exists in this schema era, so manpower-state checks are skipped."
      )
    ))
  }

  if (season >= 19831984L && season <= 19981999L) {
    return(list(
      id = "rs_ot_5on5_19831984_19981999",
      label = "Regular-season 5-on-5 OT era (1983-84 through 1998-99)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season ties can proceed to a single 5:00 OT period played at 5-on-5;",
        "there is no shootout; playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = 300L,
      regularSeasonOtSkaters = 5L,
      regularSeasonMaxPeriods = 4L,
      hasShootout = FALSE,
      rule_sources = c(
        "https://www.nhl.com/news/nhl-general-managers-discuss-overtime-format"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        "Regular-season OT is treated as a single 5:00 5-on-5 OT period in this era.",
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        "No shootout is allowed in this era.",
        "Shot-counter columns appear only near the end of this era, starting with 1997-98."
      )
    ))
  }

  if (season >= 19992000L && season <= 20032004L) {
    return(list(
      id = "rs_ot_4on4_19992000_20032004",
      label = "Regular-season 4-on-4 OT era (1999-00 through 2003-04)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season ties can proceed to a single 5:00 OT period played at 4-on-4;",
        "there is no shootout; playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = 300L,
      regularSeasonOtSkaters = 4L,
      regularSeasonMaxPeriods = 4L,
      hasShootout = FALSE,
      rule_sources = c(
        "https://www.nhl.com/news/nhl-general-managers-discuss-overtime-format"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        "Regular-season OT is treated as a single 5:00 4-on-4 OT period in this era.",
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        "No shootout is allowed in this era.",
        "No `situationCode` exists in this schema era, so manpower-state checks are skipped."
      )
    ))
  }

  if (season >= 20052006L && season <= 20142015L) {
    return(list(
      id = "rs_ot_4on4_shootout_20052006_20142015",
      label = "Regular-season 4-on-4 OT plus shootout era (2005-06 through 2014-15)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season ties go to a single 5:00 4-on-4 OT period and then, if still tied, a shootout;",
        "playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = 300L,
      regularSeasonOtSkaters = 4L,
      regularSeasonMaxPeriods = 5L,
      hasShootout = TRUE,
      rule_sources = c(
        "https://www.nhl.com/news/nhl-general-managers-discuss-overtime-format",
        "https://www.nhl.com/video/topic/top-plays/memories-first-nhl-shootout-6340445383112",
        "https://www.nhl.com/nhl/en/v3/ext/pdfs/2011-12_RULE_BOOK.pdf"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        "Regular-season OT is treated as a single 5:00 4-on-4 OT period in this era.",
        "Regular-season shootouts are allowed in this era.",
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        "The `situationCode` era begins in 2005-06, but explicit boundary rows do not appear until 2009-10."
      )
    ))
  }

  if (season >= 20152016L && season <= 20252026L) {
    return(list(
      id = "rs_ot_3on3_shootout_20152016_20252026",
      label = "Regular-season 3-on-3 OT plus shootout era (2015-16 through 2025-26)",
      description = paste(
        "Regulation is 20:00 for periods 1-3; regular-season ties go to a single 5:00 3-on-3 OT period and then, if still tied, a shootout;",
        "playoff overtime remains full 20:00 sudden-death periods."
      ),
      regularSeasonOtSeconds = 300L,
      regularSeasonOtSkaters = 3L,
      regularSeasonMaxPeriods = 5L,
      hasShootout = TRUE,
      rule_sources = c(
        "https://www.nhl.com/news/nhl-general-managers-discuss-overtime-format",
        "https://media.nhl.com/site/asset/public/ext/2023-24/2023-24Rulebook.pdf",
        "https://www.nhl.com/news/over-the-boards-dan-rosen-mailbag-july-22-317554640"
      ),
      notes = c(
        "Periods 1-3 are treated as 20:00 regulation periods.",
        "Regular-season OT is treated as a single 5:00 3-on-3 OT period in this era.",
        "Regular-season shootouts are allowed in this era.",
        "Playoff overtime periods are treated as full 20:00 OT periods.",
        paste(
          "The 2020 Return to Play round-robin seeding games `2019030002` and `2019030016` were encoded",
          "with playoff gameTypeId `3` but legally used regular-season OT/shootout rules, so the audit treats",
          "only those two games as shootout-eligible."
        ),
        paste(
          "The simple penalty-to-situationCode audit is intentionally limited to isolated, single-penalty windows",
          "with an unambiguous manpower baseline (5v5, simple 6v5 extra-attacker states, the regular-season OT base",
          "state, and simple regulation-to-OT carry-overs) so that the README does not overstate findings in",
          "coincidental or stacked-penalty edge cases."
        )
      )
    ))
  }

  stop("Unsupported season: ", season, call. = FALSE)
}

pbp_source_config <- function(source, season) {
  source <- tolower(source)
  if (!source %in% c("gc", "wsc")) {
    stop("Unsupported source: ", source, call. = FALSE)
  }

  file_name <- sprintf("%s_pbps_%s.csv", source, season)
  list(
    source = source,
    sourceLabel = toupper(source),
    fileName = file_name,
    periodCol = if (source == "gc") "periodDescriptor.number" else "period",
    periodTypeCol = if (source == "gc") "periodDescriptor.periodType" else NULL,
    eventOwnerCol = if (source == "gc") "details.eventOwnerTeamId" else "eventOwnerTeamId",
    penaltyTypeCol = if (source == "gc") "details.typeCode" else "penaltyTypeCode",
    penaltyDurationCol = if (source == "gc") "details.duration" else "duration",
    awayScoreCol = if (source == "gc") "details.awayScore" else "awayScore",
    homeScoreCol = if (source == "gc") "details.homeScore" else "homeScore",
    awaySOGCol = if (source == "gc") "details.awaySOG" else "awaySOG",
    homeSOGCol = if (source == "gc") "details.homeSOG" else "homeSOG",
    winningPlayerCol = if (source == "gc") "details.winningPlayerId" else "winningPlayerId",
    losingPlayerCol = if (source == "gc") "details.losingPlayerId" else "losingPlayerId",
    reasonCol = if (source == "gc") "details.reason" else "reason",
    secondaryReasonCol = if (source == "gc") "details.secondaryReason" else NULL
  )
}

feed_capability_chunk_for_season <- function(source, season) {
  if (season <= 19961997L) {
    return(list(
      id = "sparse_goal_penalty",
      label = "Sparse goal/penalty era",
      description = paste(
        "Only the sparse scoring/penalty backbone is available.",
        "There are no shot counters, no `situationCode`, and no explicit boundary rows."
      )
    ))
  }

  if (season >= 19971998L && season <= 20032004L) {
    return(list(
      id = "shot_counter_no_situation",
      label = "Shot-counter era without situationCode",
      description = paste(
        "Shot events and SOG counters are available, but there is still no `situationCode`",
        "and no explicit period-boundary rows."
      )
    ))
  }

  if (season >= 20052006L && season <= 20082009L) {
    return(list(
      id = "situation_no_boundary",
      label = "SituationCode era without boundary rows",
      description = paste(
        "`situationCode`, coordinates, and reason fields are available, but explicit",
        "`period-start` / `period-end` / `game-end` rows are still absent."
      )
    ))
  }

  if (season >= 20092010L && season <= 20182019L) {
    return(list(
      id = "boundary_row_era",
      label = "Boundary-row era",
      description = paste(
        "Explicit `period-start` / `period-end` / `game-end` rows and richer live-play event families are present."
      )
    ))
  }

  if (season >= 20192020L && season <= 20212022L) {
    return(list(
      id = "modern_home_side",
      label = "Modern home-defending-side era",
      description = paste(
        "Boundary rows persist and `homeTeamDefendingSide` is now present alongside the modern feed layout."
      )
    ))
  }

  if (identical(tolower(source), "gc")) {
    return(list(
      id = "latest_gc",
      label = "Latest GC era",
      description = paste(
        "Modern GC schema with `details.secondaryReason` and, from 2022-23 onward, `failed-shot-attempt` rows."
      )
    ))
  }

  list(
    id = "latest_wsc",
    label = "Latest WSC era",
    description = paste(
      "Modern WSC schema with `official-challenge` support but no GC-only clip or secondary-reason fields."
    )
  )
}

fetch_json <- function(url) {
  resp <- httr2::request(url) |>
    httr2::req_retry(
      max_tries = 3,
      backoff = function(attempt) 2 ^ (attempt - 1)
    ) |>
    httr2::req_perform()

  jsonlite::fromJSON(
    httr2::resp_body_string(resp, encoding = "UTF-8"),
    simplifyVector = TRUE,
    flatten = TRUE
  )
}

fetch_game_lookup <- function(season) {
  url <- sprintf(
    "https://api.nhle.com/stats/rest/en/game?cayenneExp=season=%s",
    as.integer(season)
  )
  payload <- fetch_json(url)
  games <- as.data.frame(payload$data, stringsAsFactors = FALSE)
  out <- data.frame(
    gameId = suppressWarnings(as.integer(games$id)),
    seasonId = suppressWarnings(as.integer(games$season)),
    gameTypeId = suppressWarnings(as.integer(games$gameType)),
    homeTeamId = suppressWarnings(as.integer(games$homeTeamId)),
    awayTeamId = suppressWarnings(as.integer(games$visitingTeamId)),
    stringsAsFactors = FALSE
  )
  out <- out[!is.na(out$gameId), , drop = FALSE]
  out <- out[order(out$gameId), , drop = FALSE]
  rownames(out) <- NULL
  out
}

game_lookup_cache <- new.env(parent = emptyenv())

fetch_game_lookup_cached <- function(season) {
  key <- as.character(as.integer(season))
  if (exists(key, envir = game_lookup_cache, inherits = FALSE)) {
    return(get(key, envir = game_lookup_cache, inherits = FALSE))
  }
  value <- fetch_game_lookup(season)
  assign(key, value, envir = game_lookup_cache)
  value
}

typed_na <- function(mode, n) {
  switch(
    mode,
    integer = rep(NA_integer_, n),
    numeric = rep(NA_real_, n),
    character = rep(NA_character_, n),
    logical = rep(NA, n),
    rep(NA_character_, n)
  )
}

pull_raw_col <- function(df, name, mode = "character") {
  n <- nrow(df)
  if (!(name %in% names(df))) {
    return(typed_na(mode, n))
  }

  x <- df[[name]]
  switch(
    mode,
    integer = suppressWarnings(as.integer(x)),
    numeric = suppressWarnings(as.numeric(x)),
    character = {
      x <- as.character(x)
      x[nchar(x) == 0L] <- NA_character_
      x
    },
    logical = as.logical(x),
    x
  )
}

derive_period_type_wsc <- function(season, game_type_id, period, ruleset) {
  out <- rep(NA_character_, length(period))
  out[!is.na(period) & period <= 3L] <- "REG"
  out[game_type_id == 3L & period >= 4L] <- "OT"

  rs_idx <- game_type_id == 2L & !is.na(period) & period >= 4L
  if (any(rs_idx)) {
    if (isTRUE(ruleset$hasShootout)) {
      out[rs_idx & period == 4L] <- "OT"
      out[rs_idx & period >= 5L] <- "SO"
    } else {
      out[rs_idx] <- "OT"
    }
  }

  out
}

normalize_situation_code <- function(situation_code) {
  sc <- as.character(situation_code)
  ok <- !is.na(sc) & grepl("^[0-9]{1,4}$", sc)
  out <- rep(NA_character_, length(sc))
  if (any(ok)) {
    out[ok] <- sprintf("%04d", as.integer(sc[ok]))
  }
  out
}

parse_situation_code <- function(situation_code) {
  sc <- normalize_situation_code(situation_code)
  data.frame(
    situationCodePadded = sc,
    awayGoalieCount = suppressWarnings(as.integer(substr(sc, 1L, 1L))),
    awaySkaterCount = suppressWarnings(as.integer(substr(sc, 2L, 2L))),
    homeSkaterCount = suppressWarnings(as.integer(substr(sc, 3L, 3L))),
    homeGoalieCount = suppressWarnings(as.integer(substr(sc, 4L, 4L))),
    stringsAsFactors = FALSE
  )
}

parse_clock <- function(time_in_period) {
  tip <- as.character(time_in_period)
  ok <- !is.na(tip) & grepl("^[0-9]{2}:[0-9]{2}$", tip)
  mins <- rep(NA_integer_, length(tip))
  secs <- rep(NA_integer_, length(tip))
  if (any(ok)) {
    mins[ok] <- suppressWarnings(as.integer(substr(tip[ok], 1L, 2L)))
    secs[ok] <- suppressWarnings(as.integer(substr(tip[ok], 4L, 5L)))
  }
  data.frame(
    clockSyntaxOK = ok,
    clockMinutes = mins,
    clockSeconds = secs,
    secondsElapsedInPeriod = ifelse(ok, mins * 60L + secs, NA_integer_),
    stringsAsFactors = FALSE
  )
}

special_round_robin_shootout_game_ids <- function(df) {
  if (!nrow(df)) {
    return(integer())
  }

  # The 2020 Return to Play round-robin seeding games were encoded with
  # playoff gameTypeId 3 even though they legally used regular-season
  # overtime/shootout rules. Only the two shootout-decided games need this
  # override; keep the exception exact so real playoff feed bugs still surface.
  round_robin_ids <- c(2019030002L, 2019030016L)
  out <- unique(df$gameId[
    !is.na(df$seasonId) &
      df$seasonId == 20192020L &
      !is.na(df$gameTypeId) &
      df$gameTypeId == 3L &
      df$gameId %in% round_robin_ids
  ])

  as.integer(sort(out))
}

max_period_seconds <- function(game_type_id, period_type, ruleset) {
  out <- rep(NA_integer_, length(period_type))
  out[period_type == "REG"] <- 1200L
  out[period_type == "SO"] <- 0L
  ot_idx <- period_type == "OT"
  out[ot_idx & game_type_id == 2L] <- ifelse(
    is.na(ruleset$regularSeasonOtSeconds),
    1200L,
    ruleset$regularSeasonOtSeconds
  )
  out[ot_idx & game_type_id == 3L] <- 1200L
  out
}

normalize_raw_pbp <- function(raw, cfg, lookup, ruleset) {
  out <- data.frame(
    gameId = pull_raw_col(raw, "gameId", "integer"),
    eventId = pull_raw_col(raw, "eventId", "integer"),
    sortOrder = pull_raw_col(raw, "sortOrder", "integer"),
    timeInPeriod = pull_raw_col(raw, "timeInPeriod", "character"),
    typeCode = pull_raw_col(raw, "typeCode", "integer"),
    typeDescKey = pull_raw_col(raw, "typeDescKey", "character"),
    situationCode = pull_raw_col(raw, "situationCode", "character"),
    period = pull_raw_col(raw, cfg$periodCol, "integer"),
    periodType = if (!is.null(cfg$periodTypeCol)) {
      pull_raw_col(raw, cfg$periodTypeCol, "character")
    } else {
      typed_na("character", nrow(raw))
    },
    eventOwnerTeamId = pull_raw_col(raw, cfg$eventOwnerCol, "integer"),
    penaltyTypeCode = pull_raw_col(raw, cfg$penaltyTypeCol, "character"),
    penaltyDuration = pull_raw_col(raw, cfg$penaltyDurationCol, "integer"),
    awayScore = pull_raw_col(raw, cfg$awayScoreCol, "integer"),
    homeScore = pull_raw_col(raw, cfg$homeScoreCol, "integer"),
    awaySOG = pull_raw_col(raw, cfg$awaySOGCol, "integer"),
    homeSOG = pull_raw_col(raw, cfg$homeSOGCol, "integer"),
    winningPlayerId = pull_raw_col(raw, cfg$winningPlayerCol, "integer"),
    losingPlayerId = pull_raw_col(raw, cfg$losingPlayerCol, "integer"),
    reason = pull_raw_col(raw, cfg$reasonCol, "character"),
    secondaryReason = if (!is.null(cfg$secondaryReasonCol)) {
      pull_raw_col(raw, cfg$secondaryReasonCol, "character")
    } else {
      typed_na("character", nrow(raw))
    },
    stringsAsFactors = FALSE
  )

  out$seasonId <- (out$gameId %/% 1000000L) * 10000L + (out$gameId %/% 1000000L) + 1L
  out$gameTypeId <- (out$gameId %/% 10000L) %% 100L
  out$gameNumber <- out$gameId %% 10000L

  out$rulesGameTypeId <- out$gameTypeId
  rr_game_ids <- special_round_robin_shootout_game_ids(out)
  if (length(rr_game_ids)) {
    out$rulesGameTypeId[out$gameId %in% rr_game_ids] <- 2L
  }

  if (cfg$source == "wsc") {
    out$periodType <- derive_period_type_wsc(
      season = unique(out$seasonId)[1L],
      game_type_id = out$rulesGameTypeId,
      period = out$period,
      ruleset = ruleset
    )
  }

  clock <- parse_clock(out$timeInPeriod)
  out <- cbind(out, clock)
  out$clockWithinSecondBounds <- !is.na(out$clockSeconds) & out$clockSeconds >= 0L & out$clockSeconds <= 59L
  out$clockWithinMinuteBounds <- !is.na(out$clockMinutes) & out$clockMinutes >= 0L
  out$periodMaxSeconds <- max_period_seconds(out$rulesGameTypeId, out$periodType, ruleset)
  out$clockWithinPeriodBounds <- !is.na(out$secondsElapsedInPeriod) &
    !is.na(out$periodMaxSeconds) &
    out$secondsElapsedInPeriod >= 0L &
    out$secondsElapsedInPeriod <= out$periodMaxSeconds

  sc <- parse_situation_code(out$situationCode)
  out <- cbind(out, sc)

  join_idx <- match(out$gameId, lookup$gameId)
  out$homeTeamId <- lookup$homeTeamId[join_idx]
  out$awayTeamId <- lookup$awayTeamId[join_idx]
  out$eventOwnerSide <- ifelse(
    out$eventOwnerTeamId == out$homeTeamId,
    "home",
    ifelse(out$eventOwnerTeamId == out$awayTeamId, "away", NA_character_)
  )

  ord <- order(out$gameId, out$sortOrder, out$eventId, na.last = TRUE)
  out <- out[ord, , drop = FALSE]
  rownames(out) <- NULL
  out$rowId <- seq_len(nrow(out))
  out
}

column_description <- function(column_name) {
  specific <- c(
    gameId = "NHL game identifier.",
    eventId = "Per-game event identifier from the source feed.",
    sortOrder = "Primary event-order field used for chronological ordering inside a game.",
    timeInPeriod = "Elapsed clock in `MM:SS` from the start of the period.",
    timeRemaining = "Clock remaining in the period as supplied by the raw feed.",
    situationCode = paste(
      "Compact away/home manpower code. In the modern feed the four digits are:",
      "away goalie, away skaters, home skaters, home goalie."
    ),
    homeTeamDefendingSide = "Home team defending side (`left` / `right`) for the current period context.",
    typeCode = "Numeric event type code from the feed.",
    typeDescKey = "Canonical event type label (for example `faceoff`, `goal`, `penalty`).",
    pptReplayUrl = "Replay URL field supplied by the GC feed.",
    period = "Period number.",
    periodDescriptor.number = "Period number in the raw GC payload.",
    periodDescriptor.periodType = "Period type in the raw GC payload (`REG`, `OT`, `SO`).",
    periodDescriptor.maxRegulationPeriods = "Maximum regulation periods recorded in the payload.",
    periodDescriptor.otPeriods = "Overtime-period metadata supplied by the payload.",
    utc = "UTC timestamp emitted by the WSC feed for the event.",
    eventOwnerTeamId = "Team credited with the event in the WSC feed.",
    penaltyTypeCode = "Penalty subtype code (`MIN`, `BEN`, `MAJ`, `MIS`, `GAM`, `MAT`, `PS`).",
    descKey = "Penalty description key in the WSC feed.",
    duration = "Penalty duration in minutes in the WSC feed.",
    committedByPlayerId = "Player assessed the penalty.",
    drawnByPlayerId = "Player who drew the penalty.",
    servedByPlayerId = "Player serving the penalty when different from the offender.",
    eventOwnerTeamId = "Team credited with the event.",
    awayScore = "Away-team score as carried on score-bearing rows.",
    homeScore = "Home-team score as carried on score-bearing rows.",
    awaySOG = "Away-team shot-on-goal counter as carried on SOG-bearing rows.",
    homeSOG = "Home-team shot-on-goal counter as carried on SOG-bearing rows.",
    losingPlayerId = "Faceoff loser or other losing actor in event-specific contexts.",
    winningPlayerId = "Faceoff winner or other winning actor in event-specific contexts.",
    xCoord = "Raw x-coordinate.",
    yCoord = "Raw y-coordinate.",
    zoneCode = "Zone label (`O`, `D`, `N`) from the feed.",
    shotType = "Shot subtype text.",
    shootingPlayerId = "Shooter credited on shot-based events.",
    goalieInNetId = "Goalie on the ice for the defending team.",
    blockingPlayerId = "Player credited with the block.",
    scoringPlayerId = "Player credited with the goal.",
    scoringPlayerTotal = "Scorer's running goal total.",
    assist1PlayerId = "Primary assist player ID.",
    assist1PlayerTotal = "Primary assister's running assist total.",
    assist2PlayerId = "Secondary assist player ID.",
    assist2PlayerTotal = "Secondary assister's running assist total.",
    playerId = "Generic event player slot used by certain event types.",
    hittingPlayerId = "Player credited with a hit.",
    hitteePlayerId = "Player receiving a hit.",
    reason = "Primary reason / stoppage cause text.",
    secondaryReason = "Secondary reason text when the feed provides one.",
    goalModifier = "Goal modifier field in the WSC feed.",
    strength = "Strength label in the WSC feed.",
    strengthCode = "Strength code in the WSC feed.",
    goalCode = "Goal code in the WSC feed.",
    officialChallenge = "Official-challenge context field."
  )

  if (column_name %in% names(specific)) {
    return(unname(specific[[column_name]]))
  }

  if (grepl("^details\\.", column_name)) {
    suffix <- sub("^details\\.", "", column_name)
    return(sprintf("Event-specific detail field `%s` from the raw flattened payload.", suffix))
  }

  if (grepl("^periodDescriptor\\.", column_name)) {
    suffix <- sub("^periodDescriptor\\.", "", column_name)
    return(sprintf("Raw period descriptor field `%s`.", suffix))
  }

  sprintf("Raw column `%s`.", column_name)
}

observed_value_string <- function(x, max_values = 12L) {
  x <- as.character(x)
  x <- x[!is.na(x) & nzchar(x)]
  if (!length(x)) {
    return("")
  }
  vals <- sort(unique(x))
  if (length(vals) > max_values) {
    vals <- c(vals[seq_len(max_values)], "...")
  }
  paste(vals, collapse = ", ")
}

build_raw_schema_table <- function(raw) {
  data.frame(
    column = names(raw),
    inferredMeaning = vapply(names(raw), column_description, character(1)),
    stringsAsFactors = FALSE
  )
}

escape_md <- function(x) {
  x <- ifelse(is.na(x), "", as.character(x))
  x <- gsub("\\|", "\\\\|", x)
  gsub("\n", " ", x, fixed = TRUE)
}

markdown_table <- function(df) {
  if (!nrow(df) || !ncol(df)) {
    return(character())
  }
  df[] <- lapply(df, escape_md)
  header <- paste0("| ", paste(names(df), collapse = " | "), " |")
  sep <- paste0("| ", paste(rep("---", ncol(df)), collapse = " | "), " |")
  rows <- apply(df, 1L, function(row) paste0("| ", paste(row, collapse = " | "), " |"))
  c(header, sep, rows)
}

simple_penalty_state_row <- function(df, idx) {
  if (is.na(idx) || idx < 1L || idx > nrow(df)) {
    return(FALSE)
  }
  if (df$periodType[idx] == "SO" || is_penalty_shot_state(df$situationCodePadded[idx])) {
    return(FALSE)
  }

  goalies_ok <- !is.na(df$homeGoalieCount[idx]) &&
    !is.na(df$awayGoalieCount[idx]) &&
    df$homeGoalieCount[idx] %in% 0:1 &&
    df$awayGoalieCount[idx] %in% 0:1
  skaters_ok <- !is.na(df$homeSkaterCount[idx]) &&
    !is.na(df$awaySkaterCount[idx]) &&
    df$homeSkaterCount[idx] >= 0L &&
    df$homeSkaterCount[idx] <= 6L &&
    df$awaySkaterCount[idx] >= 0L &&
    df$awaySkaterCount[idx] <= 6L

  goalies_ok && skaters_ok
}

is_strength_affecting_penalty_row <- function(df, idx) {
  !is.na(df$eventOwnerSide[idx]) &&
    identical(df$typeDescKey[idx], "penalty") &&
    (
      (df$penaltyTypeCode[idx] %in% c("MIN", "BEN", "MAJ") &&
        df$penaltyDuration[idx] %in% c(2L, 4L, 5L)) ||
        (identical(df$penaltyTypeCode[idx], "MAT") &&
          df$penaltyDuration[idx] %in% c(5L, 15L))
    )
}

is_simple_extra_attacker_state <- function(home_skaters, away_skaters, home_goalies, away_goalies) {
  (identical(home_goalies, 0L) &&
    identical(away_goalies, 1L) &&
    identical(home_skaters, 6L) &&
    identical(away_skaters, 5L)) ||
    (identical(home_goalies, 1L) &&
      identical(away_goalies, 0L) &&
      identical(home_skaters, 5L) &&
      identical(away_skaters, 6L))
}

simple_penalty_state_delta <- function(home_skaters, away_skaters, penalized_side) {
  if (identical(penalized_side, "home")) {
    return(c(home = home_skaters - 1L, away = away_skaters))
  }
  if (identical(penalized_side, "away")) {
    return(c(home = home_skaters, away = away_skaters - 1L))
  }
  NULL
}

map_regular_season_ot_start_counts <- function(home_skaters, away_skaters, ruleset) {
  ot_skaters <- ruleset$regularSeasonOtSkaters

  if (identical(ot_skaters, 3L)) {
    if (identical(home_skaters, 5L) && identical(away_skaters, 5L)) {
      return(c(home = 3L, away = 3L))
    }
    if (identical(home_skaters, 4L) && identical(away_skaters, 4L)) {
      return(c(home = 3L, away = 3L))
    }
    if (identical(home_skaters, 3L) && identical(away_skaters, 3L)) {
      return(c(home = 3L, away = 3L))
    }
    if (identical(home_skaters, 5L) && identical(away_skaters, 4L)) {
      return(c(home = 4L, away = 3L))
    }
    if (identical(home_skaters, 4L) && identical(away_skaters, 5L)) {
      return(c(home = 3L, away = 4L))
    }
    if (identical(home_skaters, 5L) && identical(away_skaters, 3L)) {
      return(c(home = 5L, away = 3L))
    }
    if (identical(home_skaters, 3L) && identical(away_skaters, 5L)) {
      return(c(home = 3L, away = 5L))
    }
    if (identical(home_skaters, 4L) && identical(away_skaters, 3L)) {
      return(c(home = 4L, away = 3L))
    }
    if (identical(home_skaters, 3L) && identical(away_skaters, 4L)) {
      return(c(home = 3L, away = 4L))
    }
    return(NULL)
  }

  if (identical(ot_skaters, 4L)) {
    if (identical(home_skaters, 5L) && identical(away_skaters, 5L)) {
      return(c(home = 4L, away = 4L))
    }
    if (identical(home_skaters, 4L) && identical(away_skaters, 4L)) {
      return(c(home = 4L, away = 4L))
    }
    if (identical(home_skaters, 5L) && identical(away_skaters, 4L)) {
      return(c(home = 4L, away = 3L))
    }
    if (identical(home_skaters, 4L) && identical(away_skaters, 5L)) {
      return(c(home = 3L, away = 4L))
    }
    if (identical(home_skaters, 5L) && identical(away_skaters, 3L)) {
      return(c(home = 5L, away = 3L))
    }
    if (identical(home_skaters, 3L) && identical(away_skaters, 5L)) {
      return(c(home = 3L, away = 5L))
    }
    if (identical(home_skaters, 4L) && identical(away_skaters, 3L)) {
      return(c(home = 4L, away = 3L))
    }
    if (identical(home_skaters, 3L) && identical(away_skaters, 4L)) {
      return(c(home = 3L, away = 4L))
    }
    return(NULL)
  }

  NULL
}

lookup_expected_simple_penalty_state <- function(df, pre_idx, next_idx, penalized_side, ruleset) {
  home_skaters <- df$homeSkaterCount[pre_idx]
  away_skaters <- df$awaySkaterCount[pre_idx]
  home_goalies <- df$homeGoalieCount[pre_idx]
  away_goalies <- df$awayGoalieCount[pre_idx]
  game_type_id <- df$gameTypeId[pre_idx]
  period_type <- df$periodType[pre_idx]
  restart_period_type <- df$periodType[next_idx]

  if (
    restart_period_type == "OT" &&
      period_type != "OT" &&
      game_type_id == 2L &&
      identical(home_goalies, 1L) &&
      identical(away_goalies, 1L) &&
      identical(home_skaters, 5L) &&
      identical(away_skaters, 5L)
  ) {
    post_penalty <- simple_penalty_state_delta(home_skaters, away_skaters, penalized_side)
    if (is.null(post_penalty)) {
      return(NULL)
    }
    return(map_regular_season_ot_start_counts(
      home_skaters = unname(post_penalty["home"]),
      away_skaters = unname(post_penalty["away"]),
      ruleset = ruleset
    ))
  }

  if (
    period_type == "OT" &&
      game_type_id == 2L &&
      identical(home_goalies, 1L) &&
      identical(away_goalies, 1L) &&
      identical(home_skaters, ruleset$regularSeasonOtSkaters) &&
      identical(away_skaters, ruleset$regularSeasonOtSkaters)
  ) {
    if (identical(ruleset$regularSeasonOtSkaters, 3L)) {
      if (identical(penalized_side, "home")) return(c(home = 3L, away = 4L))
      if (identical(penalized_side, "away")) return(c(home = 4L, away = 3L))
    }

    post_penalty <- simple_penalty_state_delta(home_skaters, away_skaters, penalized_side)
    if (!is.null(post_penalty)) {
      return(post_penalty)
    }
  }

  if (
    identical(home_goalies, 1L) &&
      identical(away_goalies, 1L) &&
      identical(home_skaters, 5L) &&
      identical(away_skaters, 5L)
  ) {
    return(simple_penalty_state_delta(home_skaters, away_skaters, penalized_side))
  }

  if (is_simple_extra_attacker_state(home_skaters, away_skaters, home_goalies, away_goalies)) {
    return(simple_penalty_state_delta(home_skaters, away_skaters, penalized_side))
  }

  NULL
}

is_restart_row <- function(type_desc_key) {
  !(type_desc_key %in% c(
    "penalty",
    "delayed-penalty",
    "stoppage",
    "period-start",
    "period-end",
    "game-end",
    "official-challenge",
    "shootout-complete"
  ))
}

is_penalty_restart_row <- function(type_desc_key) {
  identical(type_desc_key, "faceoff")
}

is_penalty_shot_state <- function(situation_code_padded) {
  !is.na(situation_code_padded) & situation_code_padded %in% c("0101", "1010")
}

is_pre_faceoff_administrative_event <- function(type_desc_key) {
  type_desc_key %in% c(
    "penalty",
    "delayed-penalty",
    "stoppage",
    "period-start",
    "official-challenge"
  )
}

is_intermission_administrative_event <- function(type_desc_key) {
  type_desc_key %in% c(
    "penalty",
    "delayed-penalty",
    "stoppage",
    "official-challenge",
    "shootout-complete"
  )
}

penalty_shot_context_flags <- function(df) {
  out <- is_penalty_shot_state(df$situationCodePadded)
  n <- nrow(df)
  if (n < 2L) {
    return(out)
  }

  for (i in seq_len(n)) {
    if (!(df$typeDescKey[i] %in% c("shot-on-goal", "goal", "failed-shot-attempt"))) {
      next
    }
    j <- i - 1L
    while (
      j >= 1L &&
        identical(df$gameId[j], df$gameId[i]) &&
        identical(df$period[j], df$period[i]) &&
        identical(df$timeInPeriod[j], df$timeInPeriod[i])
    ) {
      if (identical(df$typeDescKey[j], "penalty") && identical(df$penaltyTypeCode[j], "PS")) {
        out[i] <- TRUE
        break
      }
      j <- j - 1L
    }
  }

  out
}

expected_period_type <- function(game_type_id, period, ruleset) {
  if (is.na(period)) {
    return(NA_character_)
  }
  if (period <= 3L) {
    return("REG")
  }
  if (identical(game_type_id, 3L)) {
    return("OT")
  }
  if (!identical(game_type_id, 2L)) {
    return(NA_character_)
  }
  if (period > ruleset$regularSeasonMaxPeriods) {
    return(NA_character_)
  }
  if (isTRUE(ruleset$hasShootout) && identical(period, ruleset$regularSeasonMaxPeriods)) {
    return("SO")
  }
  "OT"
}

shootout_terminal_order_reason <- function(observed_order) {
  sprintf(
    paste(
      "Shootout terminal markers are ordered as `%s` in the feed,",
      "rather than the website-consistent terminal marker order",
      "`period-start -> shootout-complete -> period-end -> game-end`."
    ),
    observed_order
  )
}

check_clock_rows <- function(df) {
  findings <- list()

  bad_format_idx <- which(!is.na(df$timeInPeriod) & !df$clockSyntaxOK)
  if (length(bad_format_idx)) {
    findings <- c(findings, lapply(bad_format_idx, function(i) {
      make_finding(
        game_id = df$gameId[i],
        period = df$period[i],
        event_id = df$eventId[i],
        sort_order = df$sortOrder[i],
        time_in_period = df$timeInPeriod[i],
        type_desc_key = df$typeDescKey[i],
        reason = "Clock string is not in `MM:SS` format."
      )
    }))
  }

  bad_seconds_idx <- which(df$clockSyntaxOK & !df$clockWithinSecondBounds)
  if (length(bad_seconds_idx)) {
    findings <- c(findings, lapply(bad_seconds_idx, function(i) {
      make_finding(
        game_id = df$gameId[i],
        period = df$period[i],
        event_id = df$eventId[i],
        sort_order = df$sortOrder[i],
        time_in_period = df$timeInPeriod[i],
        type_desc_key = df$typeDescKey[i],
        reason = sprintf("Clock has an impossible seconds component (`%s`).", df$timeInPeriod[i])
      )
    }))
  }

  bad_bounds_idx <- which(
    df$clockSyntaxOK &
      df$clockWithinSecondBounds &
      !df$clockWithinPeriodBounds
  )
  if (length(bad_bounds_idx)) {
    findings <- c(findings, lapply(bad_bounds_idx, function(i) {
      make_finding(
        game_id = df$gameId[i],
        period = df$period[i],
        event_id = df$eventId[i],
        sort_order = df$sortOrder[i],
        time_in_period = df$timeInPeriod[i],
        type_desc_key = df$typeDescKey[i],
        reason = sprintf(
          "Clock falls outside the legal `%s` period length for this game context.",
          ifelse(is.na(df$periodType[i]), "period", df$periodType[i])
        )
      )
    }))
  }

  bind_findings(findings)
}

check_period_structure <- function(df, ruleset) {
  findings <- list()
  game_ids <- unique(df$gameId)
  types_present <- unique(df$typeDescKey[!is.na(df$typeDescKey)])
  has_explicit_boundaries <- all(c("period-start", "period-end", "game-end") %in% types_present)

  for (game_id in game_ids) {
    idx_game <- which(df$gameId == game_id)
    game_rows <- df[idx_game, , drop = FALSE]
    periods <- sort(unique(game_rows$period[!is.na(game_rows$period)]))
    if (!length(periods)) {
      next
    }

    expected_periods <- seq.int(1L, max(periods))
    if (has_explicit_boundaries && !identical(periods, expected_periods)) {
      findings[[length(findings) + 1L]] <- make_finding(
        game_id = game_id,
        reason = sprintf(
          "Observed periods are not contiguous starting at 1 (saw `%s`).",
          paste(periods, collapse = ",")
        )
      )
    }

    game_type_id <- unique(game_rows$gameTypeId[!is.na(game_rows$gameTypeId)])[1L]
    rules_game_type_id <- unique(game_rows$rulesGameTypeId[!is.na(game_rows$rulesGameTypeId)])[1L]
    if (identical(rules_game_type_id, 2L)) {
      bad_periods <- periods[periods > ruleset$regularSeasonMaxPeriods]
      if (length(bad_periods)) {
        i <- which(game_rows$period == bad_periods[[1]])[1L]
        findings[[length(findings) + 1L]] <- make_finding(
          game_id = game_id,
          period = game_rows$period[i],
          event_id = game_rows$eventId[i],
          sort_order = game_rows$sortOrder[i],
          time_in_period = game_rows$timeInPeriod[i],
          type_desc_key = game_rows$typeDescKey[i],
          reason = sprintf(
            "Regular-season game exceeds the legal maximum of %s periods for the `%s` ruleset chunk.",
            ruleset$regularSeasonMaxPeriods,
            ruleset$label
          )
        )
      }
    }

    if ("periodType" %in% names(game_rows)) {
      raw_period_type_idx <- which(!is.na(game_rows$periodType) & nzchar(game_rows$periodType))
      for (i in raw_period_type_idx) {
        expected_type <- expected_period_type(game_rows$rulesGameTypeId[i], game_rows$period[i], ruleset)
        if (!is.na(expected_type) && !identical(game_rows$periodType[i], expected_type)) {
          findings[[length(findings) + 1L]] <- make_finding(
            game_id = game_id,
            period = game_rows$period[i],
            event_id = game_rows$eventId[i],
            sort_order = game_rows$sortOrder[i],
            time_in_period = game_rows$timeInPeriod[i],
            type_desc_key = game_rows$typeDescKey[i],
            reason = sprintf(
              "Raw period type `%s` disagrees with the expected `%s` label for this season/game context.",
              game_rows$periodType[i],
              expected_type
            )
          )
        }
      }
    }
  }

  bind_findings(findings)
}

check_shootout_terminal_order <- function(df) {
  findings <- list()
  game_ids <- unique(df$gameId)

  for (game_id in game_ids) {
    idx_game <- which(df$gameId == game_id)
    game_rows <- df[idx_game, , drop = FALSE]
    if (!nrow(game_rows) || !any(game_rows$typeDescKey == "shootout-complete", na.rm = TRUE)) {
      next
    }

    so_rows_idx <- which(game_rows$periodType == "SO")
    if (!length(so_rows_idx)) {
      next
    }

    period_start_idx <- so_rows_idx[game_rows$typeDescKey[so_rows_idx] == "period-start"]
    shootout_complete_idx <- so_rows_idx[game_rows$typeDescKey[so_rows_idx] == "shootout-complete"]
    period_end_idx <- so_rows_idx[game_rows$typeDescKey[so_rows_idx] == "period-end"]
    game_end_idx <- which(game_rows$typeDescKey == "game-end")

    if (!length(period_start_idx) || !length(shootout_complete_idx) || !length(period_end_idx) || !length(game_end_idx)) {
      next
    }

    start_idx <- period_start_idx[[1L]]
    complete_idx <- shootout_complete_idx[[1L]]
    end_idx <- period_end_idx[[1L]]
    game_end_idx <- game_end_idx[[1L]]

    if (start_idx < complete_idx && complete_idx < end_idx && end_idx < game_end_idx) {
      next
    }

    marker_idx <- c(start_idx, complete_idx, end_idx, game_end_idx)
    marker_names <- c("period-start", "shootout-complete", "period-end", "game-end")
    marker_order <- paste(marker_names[order(marker_idx)], collapse = " -> ")
    rep_idx <- complete_idx

    findings[[length(findings) + 1L]] <- make_finding(
      game_id = game_id,
      period = game_rows$period[rep_idx],
      event_id = game_rows$eventId[rep_idx],
      sort_order = game_rows$sortOrder[rep_idx],
      time_in_period = game_rows$timeInPeriod[rep_idx],
      type_desc_key = game_rows$typeDescKey[rep_idx],
      reason = shootout_terminal_order_reason(marker_order)
    )
  }

  bind_findings(findings)
}

check_boundary_structure <- function(df) {
  findings <- list()
  game_ids <- unique(df$gameId)

  for (game_id in game_ids) {
    idx_game <- which(df$gameId == game_id)
    game_rows <- df[idx_game, , drop = FALSE]
    if (!nrow(game_rows)) {
      next
    }

    if (!identical(game_rows$typeDescKey[1L], "period-start")) {
      findings[[length(findings) + 1L]] <- make_finding(
        game_id = game_id,
        period = game_rows$period[1L],
        event_id = game_rows$eventId[1L],
        sort_order = game_rows$sortOrder[1L],
        time_in_period = game_rows$timeInPeriod[1L],
        type_desc_key = game_rows$typeDescKey[1L],
        reason = "The first row in the game is not `period-start`."
      )
    }

    game_end_pos <- which(game_rows$typeDescKey == "game-end")
    if (length(game_end_pos) != 1L) {
      findings[[length(findings) + 1L]] <- make_finding(
        game_id = game_id,
        reason = sprintf("Expected exactly 1 `game-end` row; found %s.", length(game_end_pos))
      )
    } else if (!identical(game_end_pos[[1]], nrow(game_rows))) {
      i <- game_end_pos[[1]]
      findings[[length(findings) + 1L]] <- make_finding(
        game_id = game_id,
        period = game_rows$period[i],
        event_id = game_rows$eventId[i],
        sort_order = game_rows$sortOrder[i],
        time_in_period = game_rows$timeInPeriod[i],
        type_desc_key = game_rows$typeDescKey[i],
        reason = "`game-end` is not the final row in the game."
      )
    }

    periods <- sort(unique(game_rows$period[!is.na(game_rows$period)]))
    for (period in periods) {
      idx_period <- which(game_rows$period == period)
      period_rows <- game_rows[idx_period, , drop = FALSE]
      period_type <- period_rows$periodType[which(!is.na(period_rows$periodType))[1L]]

      start_pos <- which(period_rows$typeDescKey == "period-start")
      if (length(start_pos) != 1L) {
        findings[[length(findings) + 1L]] <- make_finding(
          game_id = game_id,
          period = period,
          reason = sprintf("Expected exactly 1 `period-start` row in period %s; found %s.", period, length(start_pos))
        )
      } else {
        i <- start_pos[[1]]
        if (!identical(period_rows$secondsElapsedInPeriod[i], 0L)) {
          findings[[length(findings) + 1L]] <- make_finding(
            game_id = game_id,
            period = period,
            event_id = period_rows$eventId[i],
            sort_order = period_rows$sortOrder[i],
            time_in_period = period_rows$timeInPeriod[i],
            type_desc_key = period_rows$typeDescKey[i],
            reason = "`period-start` is not stamped at `00:00`."
          )
        }
      }

      end_pos <- which(period_rows$typeDescKey == "period-end")
      if (length(end_pos) != 1L) {
        findings[[length(findings) + 1L]] <- make_finding(
          game_id = game_id,
          period = period,
          reason = sprintf("Expected exactly 1 `period-end` row in period %s; found %s.", period, length(end_pos))
        )
      } else {
        i <- end_pos[[1]]
        expected_end <- period_rows$periodMaxSeconds[i]
        later_periods_exist <- any(game_rows$period > period, na.rm = TRUE)
        require_terminal_clock <- !identical(period_type, "OT") || later_periods_exist
        if (
          require_terminal_clock &&
            !is.na(expected_end) &&
            !identical(period_rows$secondsElapsedInPeriod[i], expected_end)
        ) {
          findings[[length(findings) + 1L]] <- make_finding(
            game_id = game_id,
            period = period,
            event_id = period_rows$eventId[i],
            sort_order = period_rows$sortOrder[i],
            time_in_period = period_rows$timeInPeriod[i],
            type_desc_key = period_rows$typeDescKey[i],
            reason = sprintf(
              "`period-end` is not stamped at the legal terminal clock for a `%s` period.",
              ifelse(is.na(period_type), "period", period_type)
            )
          )
        }
      }

      if (!identical(period_type, "SO")) {
        first_faceoff_pos <- which(period_rows$typeDescKey == "faceoff")
        if (!length(first_faceoff_pos)) {
          findings[[length(findings) + 1L]] <- make_finding(
            game_id = game_id,
            period = period,
            reason = "The period has no `faceoff` row at all."
          )
        } else {
          i <- first_faceoff_pos[[1]]
          if (!identical(period_rows$secondsElapsedInPeriod[i], 0L)) {
            findings[[length(findings) + 1L]] <- make_finding(
              game_id = game_id,
              period = period,
              event_id = period_rows$eventId[i],
              sort_order = period_rows$sortOrder[i],
              time_in_period = period_rows$timeInPeriod[i],
              type_desc_key = period_rows$typeDescKey[i],
              reason = "The opening faceoff of the period is not at `00:00`."
            )
          }
        }
      }
    }
  }

  bind_findings(findings)
}

check_pre_faceoff_events <- function(df) {
  findings <- list()
  game_ids <- unique(df$gameId)

  for (game_id in game_ids) {
    idx_game <- which(df$gameId == game_id)
    game_rows <- df[idx_game, , drop = FALSE]
    periods <- sort(unique(game_rows$period[!is.na(game_rows$period)]))

    for (period in periods) {
      idx_period <- which(game_rows$period == period)
      period_rows <- game_rows[idx_period, , drop = FALSE]
      period_type <- period_rows$periodType[which(!is.na(period_rows$periodType))[1L]]
      if (identical(period_type, "SO")) {
        next
      }

      start_pos <- which(period_rows$typeDescKey == "period-start")
      faceoff_pos <- which(period_rows$typeDescKey == "faceoff")
      if (!length(faceoff_pos)) {
        next
      }

      start_anchor <- if (length(start_pos)) start_pos[[1]] else 1L
      faceoff_anchor <- faceoff_pos[faceoff_pos > start_anchor][1L]
      if (is.na(faceoff_anchor)) {
        faceoff_anchor <- faceoff_pos[[1]]
      }

      if (faceoff_anchor <= start_anchor + 1L) {
        next
      }

      between <- seq.int(start_anchor + 1L, faceoff_anchor - 1L)
      keep_idx <- between[!is_pre_faceoff_administrative_event(period_rows$typeDescKey[between])]
      if (!length(keep_idx)) {
        next
      }

      findings <- c(findings, lapply(keep_idx, function(i) {
        make_finding(
          game_id = game_id,
          period = period_rows$period[i],
          event_id = period_rows$eventId[i],
          sort_order = period_rows$sortOrder[i],
          time_in_period = period_rows$timeInPeriod[i],
          type_desc_key = period_rows$typeDescKey[i],
          reason = "This live-play event occurs after `period-start` but before the opening faceoff of the period."
        )
      }))
    }
  }

  bind_findings(findings)
}

check_intermission_events <- function(df) {
  findings <- list()
  game_ids <- unique(df$gameId)

  for (game_id in game_ids) {
    idx_game <- which(df$gameId == game_id)
    game_rows <- df[idx_game, , drop = FALSE]
    if (!nrow(game_rows)) {
      next
    }

    in_intermission <- FALSE
    intermission_start_period <- NA_integer_
    bad_idx <- integer()

    flush_intermission <- function(end_type, next_period = NA_integer_) {
      if (!length(bad_idx)) {
        return(list(findings = list(), bad_idx = integer()))
      }

      out <- lapply(bad_idx, function(i) {
        make_finding(
          game_id = game_id,
          period = game_rows$period[i],
          event_id = game_rows$eventId[i],
          sort_order = game_rows$sortOrder[i],
          time_in_period = game_rows$timeInPeriod[i],
          type_desc_key = game_rows$typeDescKey[i],
          reason = if (identical(end_type, "period-start")) {
            sprintf(
              "This event is sandwiched between the end of period %s and the start of period %s.",
              intermission_start_period,
              next_period
            )
          } else {
            "This event occurs after the final `period-end` but before `game-end`."
          }
        )
      })

      list(findings = out, bad_idx = integer())
    }

    for (i in seq_len(nrow(game_rows))) {
      type_desc_key <- game_rows$typeDescKey[i]

      if (!in_intermission) {
        if (identical(type_desc_key, "period-end")) {
          in_intermission <- TRUE
          intermission_start_period <- game_rows$period[i]
          bad_idx <- integer()
        }
        next
      }

      if (identical(type_desc_key, "period-start")) {
        flushed <- flush_intermission("period-start", game_rows$period[i])
        findings <- c(findings, flushed$findings)
        bad_idx <- flushed$bad_idx
        in_intermission <- FALSE
        intermission_start_period <- NA_integer_
        next
      }

      if (identical(type_desc_key, "game-end")) {
        flushed <- flush_intermission("game-end")
        findings <- c(findings, flushed$findings)
        bad_idx <- flushed$bad_idx
        in_intermission <- FALSE
        intermission_start_period <- NA_integer_
        next
      }

      if (!is_intermission_administrative_event(type_desc_key)) {
        bad_idx <- c(bad_idx, i)
      }
    }
  }

  bind_findings(findings)
}

check_clock_regressions <- function(df) {
  findings <- list()
  n <- nrow(df)
  if (n < 2L) {
    return(empty_findings())
  }

  same_gp <- df$gameId[-1L] == df$gameId[-n] &
    df$period[-1L] == df$period[-n]
  bad_idx <- which(
    same_gp &
      df$clockSyntaxOK[-1L] &
      df$clockSyntaxOK[-n] &
      df$secondsElapsedInPeriod[-1L] < df$secondsElapsedInPeriod[-n]
  ) + 1L

  if (!length(bad_idx)) {
    return(empty_findings())
  }

  findings <- lapply(bad_idx, function(i) {
    make_finding(
      game_id = df$gameId[i],
      period = df$period[i],
      event_id = df$eventId[i],
      sort_order = df$sortOrder[i],
      time_in_period = df$timeInPeriod[i],
      type_desc_key = df$typeDescKey[i],
      reason = sprintf(
        "Clock regresses within the same game/period (%s follows %s).",
        df$timeInPeriod[i],
        df$timeInPeriod[i - 1L]
      )
    )
  })

  bind_findings(findings)
}

check_situation_code_shape <- function(df) {
  findings <- list()
  sc_raw <- as.character(df$situationCode)
  present <- !is.na(sc_raw) & nzchar(sc_raw)
  malformed_idx <- which(present & !grepl("^[0-9]{1,4}$", sc_raw))

  if (length(malformed_idx)) {
    findings <- c(findings, lapply(malformed_idx, function(i) {
      make_finding(
        game_id = df$gameId[i],
        period = df$period[i],
        event_id = df$eventId[i],
        sort_order = df$sortOrder[i],
        time_in_period = df$timeInPeriod[i],
        type_desc_key = df$typeDescKey[i],
        reason = sprintf("`situationCode` is not a 1-4 digit numeric token (`%s`).", sc_raw[i])
      )
    }))
  }

  parsed_idx <- which(!is.na(df$situationCodePadded))
  if (length(parsed_idx)) {
    invalid_goalie <- parsed_idx[
      !(df$awayGoalieCount[parsed_idx] %in% c(0L, 1L)) |
        !(df$homeGoalieCount[parsed_idx] %in% c(0L, 1L))
    ]
    if (length(invalid_goalie)) {
      findings <- c(findings, lapply(invalid_goalie, function(i) {
        make_finding(
          game_id = df$gameId[i],
          period = df$period[i],
          event_id = df$eventId[i],
          sort_order = df$sortOrder[i],
          time_in_period = df$timeInPeriod[i],
          type_desc_key = df$typeDescKey[i],
          reason = sprintf("`situationCode` implies an impossible goalie count (`%s`).", df$situationCodePadded[i])
        )
      }))
    }

    invalid_skaters <- parsed_idx[
      df$awaySkaterCount[parsed_idx] < 0L |
        df$awaySkaterCount[parsed_idx] > 6L |
        df$homeSkaterCount[parsed_idx] < 0L |
        df$homeSkaterCount[parsed_idx] > 6L
    ]
    if (length(invalid_skaters)) {
      findings <- c(findings, lapply(invalid_skaters, function(i) {
        make_finding(
          game_id = df$gameId[i],
          period = df$period[i],
          event_id = df$eventId[i],
          sort_order = df$sortOrder[i],
          time_in_period = df$timeInPeriod[i],
          type_desc_key = df$typeDescKey[i],
          reason = sprintf("`situationCode` implies an impossible skater count (`%s`).", df$situationCodePadded[i])
        )
      }))
    }

    low_skater_idx <- parsed_idx[
      !(df$situationCodePadded[parsed_idx] %in% c("0101", "1010")) &
        (
          df$awaySkaterCount[parsed_idx] %in% 1:2 |
            df$homeSkaterCount[parsed_idx] %in% 1:2
        )
    ]
    if (length(low_skater_idx)) {
      findings <- c(findings, lapply(low_skater_idx, function(i) {
        make_finding(
          game_id = df$gameId[i],
          period = df$period[i],
          event_id = df$eventId[i],
          sort_order = df$sortOrder[i],
          time_in_period = df$timeInPeriod[i],
          type_desc_key = df$typeDescKey[i],
          reason = sprintf(
            "`situationCode` implies fewer than 3 skaters in live play without being a shootout / penalty-shot code (`%s`).",
            df$situationCodePadded[i]
          )
        )
      }))
    }
  }

  bind_findings(findings)
}

check_simple_penalty_transitions <- function(df, ruleset) {
  findings <- list()
  n <- nrow(df)
  i <- 1L

  while (i <= n) {
    if (!identical(df$typeDescKey[i], "penalty")) {
      i <- i + 1L
      next
    }

    j <- i
    while (
      j < n &&
        identical(df$gameId[j + 1L], df$gameId[i]) &&
        identical(df$period[j + 1L], df$period[i]) &&
        identical(df$timeInPeriod[j + 1L], df$timeInPeriod[i]) &&
        identical(df$typeDescKey[j + 1L], "penalty")
    ) {
      j <- j + 1L
    }

    cluster <- i:j
    game_id <- df$gameId[i]

    strength_rows <- cluster[vapply(cluster, function(idx) is_strength_affecting_penalty_row(df, idx), logical(1))]

    if (length(strength_rows) != 1L) {
      i <- j + 1L
      next
    }

    pre_idx <- i - 1L
    while (
      pre_idx >= 1L &&
        identical(df$gameId[pre_idx], game_id) &&
        (
          is.na(df$situationCodePadded[pre_idx]) ||
            !simple_penalty_state_row(df, pre_idx)
        )
    ) {
      pre_idx <- pre_idx - 1L
    }

    if (pre_idx < 1L || !identical(df$gameId[pre_idx], game_id)) {
      i <- j + 1L
      next
    }

    penalized_side <- df$eventOwnerSide[strength_rows]
    penalty_period <- df$period[i]
    penalty_seconds <- df$secondsElapsedInPeriod[i]
    next_idx <- j + 1L
    ambiguous_post_penalty_clock <- FALSE
    while (
      next_idx <= n &&
        identical(df$gameId[next_idx], game_id)
    ) {
      if (
        identical(df$period[next_idx], penalty_period) &&
          !is.na(penalty_seconds) &&
          !is.na(df$secondsElapsedInPeriod[next_idx]) &&
          df$secondsElapsedInPeriod[next_idx] < penalty_seconds
      ) {
        ambiguous_post_penalty_clock <- TRUE
        break
      }

      if (
        is_penalty_restart_row(df$typeDescKey[next_idx]) &&
          !is.na(df$situationCodePadded[next_idx]) &&
          simple_penalty_state_row(df, next_idx)
      ) {
        break
      }

      next_idx <- next_idx + 1L
    }

    if (
      ambiguous_post_penalty_clock ||
        next_idx > n ||
        !identical(df$gameId[next_idx], game_id)
    ) {
      i <- j + 1L
      next
    }

    prev_restart_idx <- i - 1L
    while (
      prev_restart_idx >= 1L &&
        identical(df$gameId[prev_restart_idx], game_id) &&
        !is_restart_row(df$typeDescKey[prev_restart_idx])
    ) {
      prev_restart_idx <- prev_restart_idx - 1L
    }

    penalty_window_start <- if (
      prev_restart_idx >= 1L &&
        identical(df$gameId[prev_restart_idx], game_id)
    ) {
      prev_restart_idx + 1L
    } else {
      1L
    }
    penalty_window <- seq.int(penalty_window_start, next_idx - 1L)
    window_strength_rows <- penalty_window[
      vapply(penalty_window, function(idx) is_strength_affecting_penalty_row(df, idx), logical(1))
    ]
    if (length(window_strength_rows) != 1L) {
      i <- j + 1L
      next
    }

    if (
      !identical(df$homeGoalieCount[pre_idx], df$homeGoalieCount[next_idx]) ||
        !identical(df$awayGoalieCount[pre_idx], df$awayGoalieCount[next_idx])
    ) {
      i <- j + 1L
      next
    }

    expected_counts <- lookup_expected_simple_penalty_state(df, pre_idx, next_idx, penalized_side, ruleset)
    if (is.null(expected_counts)) {
      i <- j + 1L
      next
    }

    observed_home <- df$homeSkaterCount[next_idx]
    observed_away <- df$awaySkaterCount[next_idx]
    if (
      !identical(observed_home, unname(expected_counts["home"])) ||
        !identical(observed_away, unname(expected_counts["away"]))
    ) {
      findings[[length(findings) + 1L]] <- make_finding(
        game_id = game_id,
        period = df$period[next_idx],
        event_id = df$eventId[next_idx],
        sort_order = df$sortOrder[next_idx],
        time_in_period = df$timeInPeriod[next_idx],
        type_desc_key = df$typeDescKey[next_idx],
        reason = sprintf(
          paste(
            "Simple non-coincidental penalty event(s) %s should move the restart state from `%s`",
            "to home/away skaters `%s-%s`, but the ensuing faceoff row still shows `%s`."
          ),
          paste(df$eventId[cluster], collapse = ","),
          df$situationCodePadded[pre_idx],
          expected_counts["home"],
          expected_counts["away"],
          df$situationCodePadded[next_idx]
        )
      )
    }

    i <- j + 1L
  }

  bind_findings(findings)
}

check_goal_score_counters <- function(df) {
  findings <- list()
  game_ids <- unique(df$gameId)

  for (game_id in game_ids) {
    idx <- which(df$gameId == game_id & df$typeDescKey == "goal" & df$periodType != "SO")
    if (!length(idx)) {
      next
    }
    prev_home <- 0L
    prev_away <- 0L
    for (i in idx) {
      if (
        is.na(df$homeScore[i]) ||
          is.na(df$awayScore[i]) ||
          is.na(df$eventOwnerSide[i])
      ) {
        findings[[length(findings) + 1L]] <- make_finding(
          game_id = game_id,
          period = df$period[i],
          event_id = df$eventId[i],
          sort_order = df$sortOrder[i],
          time_in_period = df$timeInPeriod[i],
          type_desc_key = df$typeDescKey[i],
          reason = "Goal row is missing score fields or a home/away team mapping."
        )
        next
      }

      home_diff <- df$homeScore[i] - prev_home
      away_diff <- df$awayScore[i] - prev_away
      total_diff <- home_diff + away_diff
      score_ok <- total_diff == 1L &&
        home_diff >= 0L &&
        away_diff >= 0L &&
        (
          (identical(df$eventOwnerSide[i], "home") && identical(home_diff, 1L) && identical(away_diff, 0L)) ||
            (identical(df$eventOwnerSide[i], "away") && identical(away_diff, 1L) && identical(home_diff, 0L))
        )

      if (!score_ok) {
        findings[[length(findings) + 1L]] <- make_finding(
          game_id = game_id,
          period = df$period[i],
          event_id = df$eventId[i],
          sort_order = df$sortOrder[i],
          time_in_period = df$timeInPeriod[i],
          type_desc_key = df$typeDescKey[i],
          reason = sprintf(
            "Goal score jump is inconsistent with event owner side `%s` (prev %s-%s, current %s-%s).",
            df$eventOwnerSide[i],
            prev_away,
            prev_home,
            df$awayScore[i],
            df$homeScore[i]
          )
        )
      }

      prev_home <- df$homeScore[i]
      prev_away <- df$awayScore[i]
    }
  }

  bind_findings(findings)
}

check_shot_counters <- function(df) {
  findings <- list()
  game_ids <- unique(df$gameId)
  penalty_shot_like <- penalty_shot_context_flags(df)
  shot_like_types <- c("shot-on-goal", "goal")
  uses_modern_visible_sog <- any(df$typeDescKey %in% c("period-start", "period-end", "game-end"), na.rm = TRUE)

  for (game_id in game_ids) {
    game_idx <- which(df$gameId == game_id & df$periodType != "SO")
    counter_idx <- game_idx[
      !is.na(df$homeSOG[game_idx]) &
        !is.na(df$awaySOG[game_idx])
    ]
    if (!length(counter_idx)) {
      next
    }

    prev_home <- 0L
    prev_away <- 0L
    prev_counter_idx <- min(game_idx) - 1L

    for (i in counter_idx) {
      if (penalty_shot_like[i]) {
        prev_home <- df$homeSOG[i]
        prev_away <- df$awaySOG[i]
        prev_counter_idx <- i
        next
      }

      home_diff <- df$homeSOG[i] - prev_home
      away_diff <- df$awaySOG[i] - prev_away
      shot_ok <- FALSE
      reason <- NULL

      if (uses_modern_visible_sog) {
        if (is.na(df$eventOwnerSide[i])) {
          reason <- "Shot-counter row is missing a home/away event-owner mapping."
        } else {
          total_diff <- home_diff + away_diff
          shot_ok <- total_diff == 1L &&
            home_diff >= 0L &&
            away_diff >= 0L &&
            (
              (identical(df$eventOwnerSide[i], "home") && identical(home_diff, 1L) && identical(away_diff, 0L)) ||
                (identical(df$eventOwnerSide[i], "away") && identical(away_diff, 1L) && identical(home_diff, 0L))
            )

          if (!shot_ok) {
            reason <- sprintf(
              "Shot counter jump is inconsistent with event owner side `%s` (prev %s-%s, current %s-%s).",
              df$eventOwnerSide[i],
              prev_away,
              prev_home,
              df$awaySOG[i],
              df$homeSOG[i]
            )
          }
        }
      } else {
        interval_idx <- seq.int(prev_counter_idx + 1L, i)
        shot_like_idx <- interval_idx[
          df$periodType[interval_idx] != "SO" &
            df$typeDescKey[interval_idx] %in% shot_like_types
        ]
        unknown_owner_idx <- shot_like_idx[is.na(df$eventOwnerSide[shot_like_idx])]

        if (length(unknown_owner_idx)) {
          reason <- sprintf(
            "Shot-counter interval contains %s shot-like row(s) without a home/away event-owner mapping.",
            length(unknown_owner_idx)
          )
        } else {
          expected_home <- sum(df$eventOwnerSide[shot_like_idx] == "home")
          expected_away <- sum(df$eventOwnerSide[shot_like_idx] == "away")
          shot_ok <- home_diff >= 0L &&
            away_diff >= 0L &&
            identical(home_diff, expected_home) &&
            identical(away_diff, expected_away)

          if (!shot_ok) {
            reason <- sprintf(
              paste(
                "Shot counter jump is inconsistent with shot-like events since the previous visible counter row",
                "(expected +%s away / +%s home from %s row(s), observed +%s away / +%s home; prev %s-%s, current %s-%s)."
              ),
              expected_away,
              expected_home,
              length(shot_like_idx),
              away_diff,
              home_diff,
              prev_away,
              prev_home,
              df$awaySOG[i],
              df$homeSOG[i]
            )
          }
        }
      }

      if (!shot_ok) {
        findings[[length(findings) + 1L]] <- make_finding(
          game_id = game_id,
          period = df$period[i],
          event_id = df$eventId[i],
          sort_order = df$sortOrder[i],
          time_in_period = df$timeInPeriod[i],
          type_desc_key = df$typeDescKey[i],
          reason = reason
        )
      }

      prev_home <- df$homeSOG[i]
      prev_away <- df$awaySOG[i]
      prev_counter_idx <- i
    }
  }

  bind_findings(findings)
}

run_audit_checks <- function(df, ruleset, applicability) {
  checks <- list()

  checks$clock <- if (isTRUE(applicability$clock$applies)) {
    check_clock_rows(df)
  } else {
    empty_findings()
  }

  checks$periodStructure <- if (isTRUE(applicability$periodStructure$applies)) {
    check_period_structure(df, ruleset)
  } else {
    empty_findings()
  }

  checks$boundary <- if (isTRUE(applicability$boundary$applies)) {
    check_boundary_structure(df)
  } else {
    empty_findings()
  }

  checks$preFaceoff <- if (isTRUE(applicability$preFaceoff$applies)) {
    check_pre_faceoff_events(df)
  } else {
    empty_findings()
  }

  checks$intermission <- if (isTRUE(applicability$intermission$applies)) {
    check_intermission_events(df)
  } else {
    empty_findings()
  }

  checks$shootoutTerminalOrder <- if (isTRUE(applicability$shootoutTerminalOrder$applies)) {
    check_shootout_terminal_order(df)
  } else {
    empty_findings()
  }

  checks$clockRegression <- if (isTRUE(applicability$clockRegression$applies)) {
    check_clock_regressions(df)
  } else {
    empty_findings()
  }

  checks$situationCodeShape <- if (isTRUE(applicability$situationCodeShape$applies)) {
    check_situation_code_shape(df)
  } else {
    empty_findings()
  }

  checks$simplePenaltyState <- if (isTRUE(applicability$simplePenaltyState$applies)) {
    check_simple_penalty_transitions(df, ruleset)
  } else {
    empty_findings()
  }

  checks$goalScore <- if (isTRUE(applicability$goalScore$applies)) {
    check_goal_score_counters(df)
  } else {
    empty_findings()
  }

  checks$shotCounter <- if (isTRUE(applicability$shotCounter$applies)) {
    check_shot_counters(df)
  } else {
    empty_findings()
  }

  checks
}

category_metadata <- list(
  clock = list(
    title = "Clock Format / Bounds",
    description = paste(
      "`timeInPeriod` must be parseable as `MM:SS`, must have seconds in `00:59`,",
      "and must fit the legal period length for the season/game-type context."
    )
  ),
  periodStructure = list(
    title = "Period Structure",
    description = paste(
      "When explicit boundary rows exist, periods should be contiguous starting at 1;",
      "regular-season games should not exceed the legal period count for the season's OT/shootout rules;",
      "and raw period-type labels should match the season/game context when provided."
    )
  ),
  boundary = list(
    title = "Boundary Structure",
    description = paste(
      "Each game should open with `period-start`, every period should have exactly one",
      "`period-start` and one `period-end`, the opening faceoff of non-shootout periods",
      "should be at `00:00`, and `game-end` should be unique and final."
    )
  ),
  preFaceoff = list(
    title = "Impossible Pre-Faceoff Live-Play Events",
    description = paste(
      "After `period-start` and before the opening faceoff of a non-shootout period,",
      "administrative rows such as `penalty`, `delayed-penalty`, or `stoppage` are tolerated.",
      "Only live-play rows in that window are flagged."
    )
  ),
  intermission = list(
    title = "Impossible Intermission Events",
    description = paste(
      "Between a period's `period-end` and the next period's `period-start`, only",
      "administrative rows such as `penalty`, `delayed-penalty`, `stoppage`, and",
      "`official-challenge`, and `shootout-complete` are tolerated."
    )
  ),
  shootoutTerminalOrder = list(
    title = "Shootout Terminal Ordering",
    description = paste(
      "When a shootout is present in boundary-row feeds, the feed's terminal markers are compared",
      "against the website-consistent marker order `period-start -> shootout-complete -> period-end -> game-end`.",
      "These findings are informational ordering inconsistencies rather than hockey-rule impossibilities."
    )
  ),
  clockRegression = list(
    title = "Clock Regressions",
    description = "Within a single game/period, elapsed `timeInPeriod` should not move backward."
  ),
  situationCodeShape = list(
    title = "SituationCode Shape",
    description = paste(
      "`situationCode` must be numeric, goalie counts must be 0 or 1, skater counts must be between 0 and 6,",
      "and non-shootout live-play rows should not imply 1- or 2-skater teams unless the code is the shootout / penalty-shot shape."
    )
  ),
  simplePenaltyState = list(
    title = "Simple Penalty State Transitions",
    description = paste(
      "For a single, non-coincidental strength-affecting penalty in an unambiguous pre-penalty state",
      "(5v5, 4v4 regular-season OT, or 3v3 regular-season OT when those states are legal for the season),",
      "the ensuing faceoff row should show the expected manpower change."
    )
  ),
  goalScore = list(
    title = "Goal Score Counter Jumps",
    description = paste(
      "On non-shootout goal rows, the away/home score fields should increase by exactly one goal on the event owner's side."
    )
  ),
  shotCounter = list(
    title = "Shot Counter Jumps",
    description = paste(
      "On non-shootout rows that carry away/home SOG counters, modern boundary-row feeds are",
      "audited row-by-row (the event owner's side should move by exactly one), while legacy feeds",
      "without boundary rows are audited against all intervening `shot-on-goal` and `goal` rows",
      "since the previous visible counter row. Penalty-shot contexts are exempted."
    )
  )
)

check_applicability_for_dataset <- function(df, cfg, season) {
  has_boundary_rows <- season >= 20092010L
  has_faceoff <- season >= 20092010L
  has_situation_code <- season >= 20052006L
  has_goal_scores <- TRUE
  has_shot_counters <- season >= 19971998L

  list(
    clock = list(applies = TRUE, note = "Applicable in all seasons."),
    periodStructure = list(applies = TRUE, note = "Applicable in all seasons."),
    boundary = list(
      applies = has_boundary_rows,
      note = if (has_boundary_rows) {
        "Applicable because explicit boundary rows exist."
      } else {
        "Skipped: this schema has no explicit `period-start` / `period-end` / `game-end` rows."
      }
    ),
    preFaceoff = list(
      applies = has_boundary_rows && has_faceoff,
      note = if (has_boundary_rows && has_faceoff) {
        "Applicable because explicit boundary rows and `faceoff` rows exist."
      } else {
        "Skipped: this schema lacks the explicit boundary rows needed to audit pre-faceoff windows."
      }
    ),
    intermission = list(
      applies = has_boundary_rows,
      note = if (has_boundary_rows) {
        "Applicable because explicit boundary rows exist."
      } else {
        "Skipped: this schema has no explicit `period-end` / `period-start` rows."
      }
    ),
    shootoutTerminalOrder = list(
      applies = has_boundary_rows,
      note = if (has_boundary_rows) {
        "Applicable because explicit boundary rows exist; only games with `shootout-complete` rows can produce findings."
      } else {
        "Skipped: this schema has no explicit boundary rows."
      }
    ),
    clockRegression = list(applies = TRUE, note = "Applicable in all seasons."),
    situationCodeShape = list(
      applies = has_situation_code,
      note = if (has_situation_code) {
        "Applicable because `situationCode` exists in this schema."
      } else {
        "Skipped: this schema has no `situationCode`."
      }
    ),
    simplePenaltyState = list(
      applies = has_situation_code,
      note = if (has_situation_code) {
        "Applicable because `situationCode` exists in this schema."
      } else {
        "Skipped: this schema has no `situationCode`, so manpower-state transitions cannot be audited."
      }
    ),
    goalScore = list(
      applies = has_goal_scores,
      note = if (has_goal_scores) {
        "Applicable because score-bearing goal rows exist."
      } else {
        "Skipped: this schema has no away/home score fields."
      }
    ),
    shotCounter = list(
      applies = has_shot_counters,
      note = if (has_shot_counters) {
        "Applicable because away/home SOG counters exist."
      } else {
        "Skipped: this schema has no away/home SOG counters."
      }
    )
  )
}

summary_table_from_checks <- function(checks, applicability) {
  data.frame(
    category = names(checks),
    title = vapply(names(checks), function(name) category_metadata[[name]]$title, character(1)),
    applies = vapply(names(checks), function(name) {
      if (isTRUE(applicability[[name]]$applies)) "yes" else "no"
    }, character(1)),
    games = vapply(checks, function(x) length(unique(x$gameId[!is.na(x$gameId)])), integer(1)),
    findings = vapply(checks, nrow, integer(1)),
    note = vapply(names(checks), function(name) applicability[[name]]$note, character(1)),
    stringsAsFactors = FALSE
  )
}

format_findings_table <- function(findings) {
  if (!nrow(findings)) {
    return("No findings in this category.")
  }

  findings <- findings[order(
    findings$gameId,
    findings$period,
    findings$sortOrder,
    findings$eventId,
    na.last = TRUE
  ), , drop = FALSE]

  tbl <- findings[, c(
    "gameId",
    "period",
    "eventId",
    "sortOrder",
    "timeInPeriod",
    "typeDescKey",
    "reason"
  )]
  names(tbl) <- c("gameId", "period", "eventId", "sortOrder", "clock", "event", "reason")
  markdown_table(tbl)
}

season_result_from_audit <- function(raw, normalized, checks, applicability, cfg, ruleset, schema_chunk, season) {
  list(
    season = as.integer(season),
    cfg = cfg,
    ruleset = ruleset,
    schemaChunk = schema_chunk,
    rows = nrow(raw),
    games = length(unique(normalized$gameId)),
    gameTypes = sort(unique(normalized$gameTypeId[!is.na(normalized$gameTypeId)])),
    periodTypes = sort(unique(normalized$periodType[!is.na(normalized$periodType)])),
    rawColumns = names(raw),
    typeValues = sort(unique(normalized$typeDescKey[!is.na(normalized$typeDescKey)])),
    penaltyValues = sort(unique(normalized$penaltyTypeCode[!is.na(normalized$penaltyTypeCode)])),
    applicability = applicability,
    checks = checks
  )
}

group_results_by_key <- function(results, key_fn) {
  if (!length(results)) {
    return(list())
  }

  out <- list()
  current <- list(
    start = results[[1]]$season,
    end = results[[1]]$season,
    value = key_fn(results[[1]])
  )

  if (length(results) == 1L) {
    return(list(current))
  }

  for (i in 2:length(results)) {
    value <- key_fn(results[[i]])
    if (identical(value$id, current$value$id)) {
      current$end <- results[[i]]$season
    } else {
      out[[length(out) + 1L]] <- current
      current <- list(
        start = results[[i]]$season,
        end = results[[i]]$season,
        value = value
      )
    }
  }

  out[[length(out) + 1L]] <- current
  out
}

build_overall_summary <- function(results) {
  categories <- names(category_metadata)
  data.frame(
    category = categories,
    title = vapply(categories, function(name) category_metadata[[name]]$title, character(1)),
    applicableSeasons = vapply(categories, function(name) {
      sum(vapply(results, function(result) isTRUE(result$applicability[[name]]$applies), logical(1)))
    }, integer(1)),
    affectedGames = vapply(categories, function(name) {
      length(unique(unlist(lapply(results, function(result) {
        result$checks[[name]]$gameId[!is.na(result$checks[[name]]$gameId)]
      }), use.names = FALSE)))
    }, integer(1)),
    findings = vapply(categories, function(name) {
      sum(vapply(results, function(result) nrow(result$checks[[name]]), integer(1)))
    }, integer(1)),
    stringsAsFactors = FALSE
  )
}

total_findings_for_result <- function(result) {
  sum(vapply(result$checks, nrow, integer(1)))
}

affected_games_for_result <- function(result) {
  length(unique(unlist(lapply(result$checks, function(findings) {
    findings$gameId[!is.na(findings$gameId)]
  }), use.names = FALSE)))
}

build_season_totals <- function(results) {
  categories <- names(category_metadata)
  rows <- lapply(results, function(result) {
    data.frame(
      season = result$season,
      rulesetChunk = result$ruleset$label,
      schemaChunk = result$schemaChunk$label,
      rows = result$rows,
      games = result$games,
      affectedGames = affected_games_for_result(result),
      totalFindings = total_findings_for_result(result),
      setNames(
        as.list(vapply(categories, function(name) nrow(result$checks[[name]]), integer(1))),
        categories
      ),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  })

  out <- do.call(rbind, rows)
  out[order(out$season), , drop = FALSE]
}

build_chunk_totals <- function(results, chunk_type = c("ruleset", "schema")) {
  chunk_type <- match.arg(chunk_type)
  categories <- names(category_metadata)
  extractor <- if (identical(chunk_type, "ruleset")) {
    function(result) result$ruleset
  } else {
    function(result) result$schemaChunk
  }

  chunk_ids <- unique(vapply(results, function(result) extractor(result)$id, character(1)))
  rows <- lapply(chunk_ids, function(chunk_id) {
    chunk_results <- Filter(function(result) identical(extractor(result)$id, chunk_id), results)
    chunk_meta <- extractor(chunk_results[[1]])
    seasons <- vapply(chunk_results, function(result) result$season, integer(1))
    affected_games <- unique(unlist(lapply(chunk_results, function(result) {
      unlist(lapply(result$checks, function(findings) findings$gameId[!is.na(findings$gameId)]), use.names = FALSE)
    }), use.names = FALSE))

    data.frame(
      chunk = chunk_meta$label,
      seasonRange = format_season_span(seasons),
      seasons = length(chunk_results),
      rows = sum(vapply(chunk_results, function(result) result$rows, integer(1))),
      games = sum(vapply(chunk_results, function(result) result$games, integer(1))),
      affectedGames = length(affected_games),
      totalFindings = sum(vapply(chunk_results, total_findings_for_result, integer(1))),
      setNames(
        as.list(vapply(categories, function(name) {
          sum(vapply(chunk_results, function(result) nrow(result$checks[[name]]), integer(1)))
        }, integer(1))),
        categories
      ),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  })

  do.call(rbind, rows)
}

build_findings_csv <- function(results, source) {
  categories <- names(category_metadata)
  rows <- list()

  for (result in results) {
    for (name in categories) {
      findings <- result$checks[[name]]
      if (!nrow(findings)) {
        next
      }

      rows[[length(rows) + 1L]] <- data.frame(
        source = toupper(source),
        season = result$season,
        sourceFile = result$cfg$fileName,
        rulesetChunk = result$ruleset$label,
        schemaChunk = result$schemaChunk$label,
        category = name,
        title = category_metadata[[name]]$title,
        reason = findings$reason,
        gameId = findings$gameId,
        sortOrder = findings$sortOrder,
        eventId = findings$eventId,
        period = findings$period,
        timeInPeriod = findings$timeInPeriod,
        typeDescKey = findings$typeDescKey,
        stringsAsFactors = FALSE,
        check.names = FALSE
      )
    }
  }

  if (!length(rows)) {
    return(data.frame(
      source = character(),
      season = integer(),
      sourceFile = character(),
      rulesetChunk = character(),
      schemaChunk = character(),
      category = character(),
      title = character(),
      reason = character(),
      gameId = integer(),
      sortOrder = integer(),
      eventId = integer(),
      period = integer(),
      timeInPeriod = character(),
      typeDescKey = character(),
      stringsAsFactors = FALSE,
      check.names = FALSE
    ))
  }

  out <- do.call(rbind, rows)
  category_order <- match(out$category, categories)
  out[order(out$season, category_order, out$gameId, out$period, out$sortOrder, out$eventId), , drop = FALSE]
}

validate_findings_csv <- function(findings_csv, source) {
  if (!nrow(findings_csv)) {
    return(invisible(NULL))
  }

  exact_keys <- paste(
    findings_csv$category,
    findings_csv$gameId,
    findings_csv$sortOrder,
    findings_csv$eventId,
    findings_csv$reason,
    sep = "||"
  )
  exact_dup <- duplicated(exact_keys)
  if (any(exact_dup)) {
    dup_row <- findings_csv[which(exact_dup)[1L], , drop = FALSE]
    stop(
      sprintf(
        "%s findings contain an exact duplicate row for category `%s`, game `%s`, event `%s`, sortOrder `%s`.",
        toupper(source),
        dup_row$category,
        dup_row$gameId,
        dup_row$eventId,
        dup_row$sortOrder
      ),
      call. = FALSE
    )
  }

  period_idx <- findings_csv$category == "periodStructure" &
    !is.na(findings_csv$eventId) &
    nzchar(findings_csv$eventId)
  period_rows <- findings_csv[period_idx, , drop = FALSE]
  if (nrow(period_rows)) {
    event_keys <- paste(period_rows$gameId, period_rows$eventId, sep = "||")
    grouped <- split(period_rows$reason, event_keys)
    bad_keys <- names(grouped)[vapply(grouped, function(reasons) {
      any(grepl("exceeds the legal maximum", reasons, fixed = TRUE)) &&
        any(grepl("Raw period type", reasons, fixed = TRUE))
    }, logical(1))]

    if (length(bad_keys)) {
      parts <- strsplit(bad_keys[[1L]], "\\|\\|")[[1L]]
      stop(
        sprintf(
          paste(
            "%s findings contain incompatible `periodStructure` reasons for game `%s`, event `%s`:",
            "an illegal extra-period finding and a raw-period-type mismatch on the same event."
          ),
          toupper(source),
          parts[[1L]],
          parts[[2L]]
        ),
        call. = FALSE
      )
    }
  }

  key_by_row <- paste(
    findings_csv$gameId,
    findings_csv$sortOrder,
    findings_csv$eventId,
    sep = "||"
  )

  intermission_idx <- findings_csv$category == "intermission"
  if (any(intermission_idx)) {
    intermission_dup <- duplicated(key_by_row[intermission_idx])
    if (any(intermission_dup)) {
      dup_row <- findings_csv[which(intermission_idx)[which(intermission_dup)[1L]], , drop = FALSE]
      stop(
        sprintf(
          "%s findings contain multiple `intermission` reasons for game `%s`, event `%s`, sortOrder `%s`.",
          toupper(source),
          dup_row$gameId,
          dup_row$eventId,
          dup_row$sortOrder
        ),
        call. = FALSE
      )
    }
  }

  simple_penalty_idx <- findings_csv$category == "simplePenaltyState"
  if (any(simple_penalty_idx)) {
    simple_penalty_dup <- duplicated(key_by_row[simple_penalty_idx])
    if (any(simple_penalty_dup)) {
      dup_row <- findings_csv[which(simple_penalty_idx)[which(simple_penalty_dup)[1L]], , drop = FALSE]
      stop(
        sprintf(
          "%s findings contain multiple `simplePenaltyState` reasons for game `%s`, event `%s`, sortOrder `%s`.",
          toupper(source),
          dup_row$gameId,
          dup_row$eventId,
          dup_row$sortOrder
        ),
        call. = FALSE
      )
    }

    non_faceoff_idx <- which(simple_penalty_idx & findings_csv$typeDescKey != "faceoff")
    if (length(non_faceoff_idx)) {
      bad_row <- findings_csv[non_faceoff_idx[1L], , drop = FALSE]
      stop(
        sprintf(
          paste(
            "%s findings contain a `simplePenaltyState` row that is not an ensuing faceoff",
            "for game `%s`, event `%s`, sortOrder `%s`, type `%s`."
          ),
          toupper(source),
          bad_row$gameId,
          bad_row$eventId,
          bad_row$sortOrder,
          bad_row$typeDescKey
        ),
        call. = FALSE
      )
    }
  }

  shootout_order_idx <- findings_csv$category == "shootoutTerminalOrder"
  if (any(shootout_order_idx)) {
    non_so_complete_idx <- which(shootout_order_idx & findings_csv$typeDescKey != "shootout-complete")
    if (length(non_so_complete_idx)) {
      bad_row <- findings_csv[non_so_complete_idx[1L], , drop = FALSE]
      stop(
        sprintf(
          paste(
            "%s findings contain a `shootoutTerminalOrder` row that is not a `shootout-complete` event",
            "for game `%s`, event `%s`, sortOrder `%s`, type `%s`."
          ),
          toupper(source),
          bad_row$gameId,
          bad_row$eventId,
          bad_row$sortOrder,
          bad_row$typeDescKey
        ),
        call. = FALSE
      )
    }
  }

  grouped_categories <- split(findings_csv$category, key_by_row)
  overlap_keys <- names(grouped_categories)[vapply(grouped_categories, function(cats) {
    any(cats == "intermission") && any(cats == "preFaceoff")
  }, logical(1))]
  if (length(overlap_keys)) {
    parts <- strsplit(overlap_keys[[1L]], "\\|\\|")[[1L]]
    stop(
      sprintf(
        paste(
          "%s findings contain incompatible `intermission` and `preFaceoff` categories",
          "for game `%s`, event `%s`, sortOrder `%s`."
        ),
        toupper(source),
        parts[[1L]],
        parts[[3L]],
        parts[[2L]]
      ),
      call. = FALSE
    )
  }

  invisible(NULL)
}

write_findings_csv <- function(results, source, csv_path) {
  findings_csv <- build_findings_csv(results, source)
  validate_findings_csv(findings_csv, source)
  write.csv(findings_csv, file = csv_path, row.names = FALSE, na = "")
}

audit_csv_filename <- function(source) {
  sprintf("%s_audit.csv", tolower(source))
}

build_column_timeline_table <- function(results) {
  all_columns <- sort(unique(unlist(lapply(results, function(result) result$rawColumns), use.names = FALSE)))
  data.frame(
    column = all_columns,
    firstSeason = vapply(all_columns, function(column) {
      min(vapply(results, function(result) {
        if (column %in% result$rawColumns) result$season else Inf
      }, numeric(1)))
    }, numeric(1)),
    lastSeason = vapply(all_columns, function(column) {
      max(vapply(results, function(result) {
        if (column %in% result$rawColumns) result$season else -Inf
      }, numeric(1)))
    }, numeric(1)),
    inferredMeaning = vapply(all_columns, column_description, character(1)),
    stringsAsFactors = FALSE
  )
}

build_event_type_timeline_table <- function(results) {
  all_types <- sort(unique(unlist(lapply(results, function(result) result$typeValues), use.names = FALSE)))
  data.frame(
    typeDescKey = all_types,
    firstSeason = vapply(all_types, function(type_desc_key) {
      min(vapply(results, function(result) {
        if (type_desc_key %in% result$typeValues) result$season else Inf
      }, numeric(1)))
    }, numeric(1)),
    lastSeason = vapply(all_types, function(type_desc_key) {
      max(vapply(results, function(result) {
        if (type_desc_key %in% result$typeValues) result$season else -Inf
      }, numeric(1)))
    }, numeric(1)),
    stringsAsFactors = FALSE
  )
}

build_feature_timeline_table <- function(results, source) {
  feature_checks <- list(
    `shot counters` = function(result) any(c(result$cfg$awaySOGCol, result$cfg$homeSOGCol) %in% result$rawColumns),
    `situationCode` = function(result) "situationCode" %in% result$rawColumns,
    `faceoff events` = function(result) "faceoff" %in% result$typeValues,
    `period-start / period-end / game-end rows` = function(result) {
      all(c("period-start", "period-end", "game-end") %in% result$typeValues)
    },
    `stoppage events` = function(result) "stoppage" %in% result$typeValues,
    `blocked-shot events` = function(result) "blocked-shot" %in% result$typeValues,
    `delayed-penalty events` = function(result) "delayed-penalty" %in% result$typeValues,
    `shootout-complete events` = function(result) "shootout-complete" %in% result$typeValues,
    `homeTeamDefendingSide` = function(result) "homeTeamDefendingSide" %in% result$rawColumns
  )

  if (identical(tolower(source), "gc")) {
    feature_checks$`details.secondaryReason` <- function(result) "details.secondaryReason" %in% result$rawColumns
    feature_checks$`failed-shot-attempt events` <- function(result) "failed-shot-attempt" %in% result$typeValues
  } else {
    feature_checks$`official-challenge events` <- function(result) "official-challenge" %in% result$typeValues
  }

  rows <- lapply(names(feature_checks), function(feature) {
    seasons <- vapply(results, function(result) {
      if (feature_checks[[feature]](result)) result$season else NA_integer_
    }, integer(1))
    seasons <- seasons[!is.na(seasons)]
    data.frame(
      feature = feature,
      firstSeason = if (length(seasons)) as.character(min(seasons)) else "never",
      lastSeason = if (length(seasons)) as.character(max(seasons)) else "never",
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}

format_markdown_section <- function(title, description, bullets = character()) {
  c(
    sprintf("### %s", title),
    description,
    if (length(bullets)) paste0("- ", bullets) else character(),
    ""
  )
}

build_notable_game_sections <- function(results) {
  target_game_id <- 2019030016L
  target_results <- Filter(function(result) {
    any(vapply(result$checks, function(findings) {
      any(findings$gameId == target_game_id, na.rm = TRUE)
    }, logical(1)))
  }, results)

  if (!length(target_results)) {
    return(character())
  }

  category_counts <- vapply(names(category_metadata), function(name) {
    sum(vapply(target_results, function(result) {
      sum(result$checks[[name]]$gameId == target_game_id, na.rm = TRUE)
    }, integer(1)))
  }, integer(1))

  summary_bits <- category_counts[category_counts > 0L]
  summary_text <- if (length(summary_bits)) {
    paste(
      paste(names(summary_bits), summary_bits, sep = "="),
      collapse = ", "
    )
  } else {
    "no findings recorded"
  }

  c(
    "## Notable Games",
    "### `2019030016`",
    paste(
      "This 2019-20 Return to Play round-robin game is a severe feed-corruption case in both GC and WSC,",
      "not just a mild shootout-ordering inconsistency."
    ),
    paste(
      "- Periods 1 through 4 each emit a `period-end` row at `00:00` almost immediately after `period-start`,",
      "and then the same period continues with substantial live play afterward."
    ),
    paste(
      "- The raw continuation after those premature `period-end` rows runs through approximately",
      "`19:57` in period 1, `19:48` in period 2, `19:47` in period 3, and `04:41` in period 4."
    ),
    paste(
      "- The shootout period then has terminal markers in the order",
      "`period-end -> shootout-complete -> period-start -> shootout attempts -> game-end`."
    ),
    paste(
      "- Because this is one root boundary-ordering failure rather than many independent hockey-rule errors,",
      "the game simultaneously drives findings in multiple categories:",
      summary_text, "."
    ),
    paste(
      "- A stricter cross-season scan for this exact severe pattern",
      "(`period-end` at `00:00` or very early, followed by substantial same-period play) matched only this game in each source."
    ),
    ""
  )
}

write_multi_season_audit_readme <- function(results, source, readme_path) {
  if (!length(results)) {
    stop("No season results to write.", call. = FALSE)
  }

  results <- results[order(vapply(results, function(result) result$season, integer(1)))]
  overall_summary <- build_overall_summary(results)
  season_totals <- build_season_totals(results)
  ruleset_totals <- build_chunk_totals(results, "ruleset")
  schema_totals <- build_chunk_totals(results, "schema")
  column_timeline <- build_column_timeline_table(results)
  event_timeline <- build_event_type_timeline_table(results)
  feature_timeline <- build_feature_timeline_table(results, source)
  ruleset_groups <- group_results_by_key(results, function(result) result$ruleset)
  schema_groups <- group_results_by_key(results, function(result) result$schemaChunk)

  total_rows <- sum(vapply(results, function(result) result$rows, numeric(1)))
  total_games <- sum(vapply(results, function(result) result$games, numeric(1)))
  all_game_types <- sort(unique(unlist(lapply(results, function(result) result$gameTypes), use.names = FALSE)))
  csv_name <- audit_csv_filename(source)

  lines <- c(
    sprintf("# %s Play-by-Play Audit", toupper(source)),
    "",
    sprintf(
      "Autogenerated by `%s/audit.R` on %s for `%s` audited seasons (`%s`).",
      tolower(source),
      format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"),
      length(results),
      format_season_span(vapply(results, function(result) result$season, integer(1)))
    ),
    "",
    "## Scope",
    sprintf("- Seasons audited: `%s`", length(results)),
    sprintf("- Season range: `%s`", format_season_span(vapply(results, function(result) result$season, integer(1)))),
    sprintf("- Source files audited: `%s`", length(results)),
    sprintf("- Rows audited: `%s`", format(total_rows, big.mark = ",")),
    sprintf("- Games audited: `%s`", format(total_games, big.mark = ",")),
    sprintf("- Game types observed: `%s`", paste(all_game_types, collapse = ", ")),
    sprintf("- Detailed findings CSV: `%s`", csv_name),
    "",
    "## Ruleset Chunks"
  )

  for (group in ruleset_groups) {
    lines <- c(
      lines,
      format_markdown_section(
        title = sprintf("`%s` (%s)", group$value$label, format_season_span(c(group$start, group$end))),
        description = group$value$description,
        bullets = c(
          group$value$notes,
          sprintf("Official sources: %s", paste(group$value$rule_sources, collapse = " | "))
        )
      )
    )
  }

  lines <- c(lines, "## Feed Capability Chunks")
  for (group in schema_groups) {
    lines <- c(
      lines,
      format_markdown_section(
        title = sprintf("`%s` (%s)", group$value$label, format_season_span(c(group$start, group$end))),
        description = group$value$description
      )
    )
  }

  lines <- c(
    lines,
    "## Raw Column Timeline",
    markdown_table(column_timeline),
    "",
    "## Event Type Timeline",
    markdown_table(event_timeline),
    "",
    "## Feature Timeline",
    markdown_table(feature_timeline),
    "",
    "## Check Definitions",
    unlist(lapply(names(category_metadata), function(name) {
      c(
        sprintf("### `%s`", name),
        category_metadata[[name]]$description,
        ""
      )
    }), use.names = FALSE),
    "## Overall Summary",
    markdown_table(overall_summary),
    "",
    build_notable_game_sections(results),
    "## Ruleset Chunk Totals",
    markdown_table(ruleset_totals),
    "",
    "## Feed Capability Chunk Totals",
    markdown_table(schema_totals),
    "",
    "## Season Totals",
    markdown_table(season_totals),
    "",
    "## Detailed Findings",
    sprintf(
      "All event-level findings have been written to `%s` in this directory. Each row contains the source, season, source file, ruleset chunk, feed-capability chunk, check category, and the specific game/event context plus the finding reason.",
      csv_name
    )
  )

  writeLines(lines, con = readme_path, useBytes = TRUE)
}

process_pbp_season <- function(source, season, source_dir) {
  ruleset <- audit_ruleset_for_season(season)
  schema_chunk <- feed_capability_chunk_for_season(source, season)
  cfg <- pbp_source_config(source, season)
  csv_path <- file.path(source_dir, cfg$fileName)
  if (!file.exists(csv_path)) {
    stop("Missing source CSV: ", csv_path, call. = FALSE)
  }

  raw <- read.csv(csv_path, stringsAsFactors = FALSE, check.names = FALSE)
  lookup <- fetch_game_lookup_cached(season)
  normalized <- normalize_raw_pbp(raw, cfg, lookup, ruleset)
  applicability <- check_applicability_for_dataset(normalized, cfg, season)
  checks <- run_audit_checks(normalized, ruleset, applicability)

  season_result_from_audit(
    raw = raw,
    normalized = normalized,
    checks = checks,
    applicability = applicability,
    cfg = cfg,
    ruleset = ruleset,
    schema_chunk = schema_chunk,
    season = season
  )
}

list_source_seasons <- function(source_dir, source) {
  pattern <- sprintf("^%s_pbps_[0-9]{8}\\.csv$", tolower(source))
  files <- sort(list.files(source_dir, pattern = pattern, full.names = FALSE))
  sort(as.integer(sub(sprintf("^%s_pbps_([0-9]{8})\\.csv$", tolower(source)), "\\1", files)))
}

run_pbp_audit <- function(source, seasons, source_dir) {
  seasons <- sort(unique(as.integer(seasons)))
  results <- lapply(seasons, function(season) process_pbp_season(source, season, source_dir))
  readme_path <- file.path(source_dir, "README.md")
  csv_path <- file.path(source_dir, audit_csv_filename(source))
  write_multi_season_audit_readme(results, source, readme_path)
  write_findings_csv(results, source, csv_path)

  invisible(list(
    seasons = seasons,
    results = results,
    readme = readme_path,
    csv = csv_path
  ))
}
