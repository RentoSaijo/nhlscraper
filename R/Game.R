#' Access all the games
#'
#' `games()` retrieves all the games as a `data.frame` where each row represents game and includes detail on game timeline state, period/clock progression, and matchup flow plus date/season filtering windows and chronological context.
#'
#' @returns data.frame with one row per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_games <- games()}
#' @export

games <- function() {
  tryCatch({
    games <- nhl_api(
      path = 'en/game',
      type = 's'
    )$data
    names(games)[names(games) == 'id']       <- 'gameId'
    names(games)[names(games) == 'season']   <- 'seasonId'
    names(games)[names(games) == 'gameType'] <- 'gameTypeId'
    games[order(games$gameId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the scores for a date
#'
#' `scores()` retrieves the scores for a date as a `data.frame` where each row represents game and includes detail on game timeline state, period/clock progression, and matchup flow, date/season filtering windows and chronological context, and team identity, affiliation, and matchup-side context.
#'
#' @inheritParams standings
#'
#' @returns data.frame with one row per game
#' @examples
#' scores_Halloween_2025 <- scores(date = '2025-10-31')
#' @export

scores <- function(date = 'now') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf('v1/score/%s', date),
        type = 'w'
      )$games
      names(games)[names(games) == 'id']       <- 'gameId'
      names(games)[names(games) == 'season']   <- 'seasonId'
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      names(games) <- normalize_locale_names(names(games))
      names(games) <- normalize_team_abbrev_cols(names(games))
      games[order(games$gameId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the GameCenter (GC) summary for a game
#'
#' `gc_summary()` retrieves the GameCenter (GC) summary for a game as a nested `list` that separates summary and detail blocks for game timeline state, period/clock progression, and matchup flow, date/season filtering windows and chronological context, and venue/location geography and regional metadata.
#'
#' @param game integer ID (e.g., 2025020275); see [games()] for reference
#'
#' @returns list of various items
#' @examples
#' gc_summary_Martin_Necas_legacy_game <- gc_summary(game = 2025020275)
#' @export

gc_summary <- function(game = 2023030417) {
  tryCatch(
    expr = {
      landing    <- nhl_api(
        path = sprintf('v1/gamecenter/%s/landing', game),
        type = 'w'
      )
      right_rail <- nhl_api(
        path = sprintf('v1/gamecenter/%s/right-rail', game),
        type = 'w'
      )
      summary <- c(landing, right_rail)
      names(summary)[names(summary) == 'id']       <- 'gameId'
      names(summary)[names(summary) == 'season']   <- 'seasonId'
      names(summary)[names(summary) == 'gameType'] <- 'gameTypeId'
      summary
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the World Showcase (WSC) summary for a game
#'
#' `wsc_summary()` retrieves the World Showcase (WSC) summary for a game as a nested `list` that separates summary and detail blocks for game timeline state, period/clock progression, and matchup flow, date/season filtering windows and chronological context, and venue/location geography and regional metadata.
#'
#' @inheritParams gc_summary
#'
#' @returns list of various items
#' @examples
#' wsc_summary_Martin_Necas_legacy_game <- wsc_summary(game = 2025020275)
#' @export

wsc_summary <- function(game = 2023030417) {
  tryCatch(
    expr = {
      summary <- nhl_api(
        path = sprintf('v1/wsc/game-story/%s', game),
        type = 'w'
      )
      names(summary)[names(summary) == 'id']       <- 'gameId'
      names(summary)[names(summary) == 'season']   <- 'seasonId'
      names(summary)[names(summary) == 'gameType'] <- 'gameTypeId'
      summary
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the boxscore for a game, team, and position
#'
#' `boxscore()` retrieves the boxscore for a game, team, and position as a `data.frame` where each row represents player and includes detail on player identity, role, handedness, and biographical profile plus production, workload, efficiency, and result-level performance outcomes.
#'
#' @inheritParams gc_summary
#' @inheritParams roster
#' @param team character of 'h'/'home' or 'a'/'away'
#'
#' @returns data.frame with one row per player
#' @examples
#' boxscore_COL_forwards_Martin_Necas_legacy_game <- boxscore(
#'   game     = 2025020275,
#'   team     = 'H',
#'   position = 'F'
#' )
#' @export

boxscore <- function(
  game     = 2023030417,
  team     = 'home',
  position = 'forwards'
) {
  tryCatch(
    expr = {
      team <- switch(
        substring(tolower(team), 1, 1),
        h = 'home',
        a = 'away'
      )
      position <- switch(
        substring(tolower(position), 1, 1),
        f = 'forwards',
        d = 'defense',
        g = 'goalies'
      )
      boxscore <- nhl_api(
        path = sprintf('v1/gamecenter/%s/boxscore', game),
        type = 'w'
      )$playerByGameStats
      boxscore <- boxscore[[paste0(team, 'Team')]][[position]]
      names(boxscore)[names(boxscore) == 'position'] <- 'positionCode'
      names(boxscore) <- normalize_locale_names(names(boxscore))
      names(boxscore) <- scope_person_name_cols(names(boxscore), 'player')
      boxscore
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the rosters for a game
#'
#' `game_rosters()` retrieves the rosters for a game as a `data.frame` where each row represents player and includes detail on team identity, affiliation, and matchup-side context plus player identity, role, handedness, and biographical profile.
#'
#' @inheritParams gc_summary
#'
#' @returns data.frame with one row per player
#' @examples
#' rosters_Martin_Necas_legacy_game <- game_rosters(game = 2025020275)
#' @export

game_rosters <- function(game = 2023030417) {
  tryCatch(
    expr = {
      rosters <- nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$rosterSpots
      names(rosters) <- normalize_locale_names(names(rosters))
      names(rosters) <- scope_person_name_cols(names(rosters), 'player')
      rosters <- rosters[order(rosters$sweaterNumber), ]
      rosters[order(rosters$teamId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' List strength-context event types
#'
#' `.supported_strength_event_types()` returns the event types that support the
#' HTML-derived strength and on-ice enrichment pipeline.
#'
#' @returns character vector of supported event type keys
#' @keywords internal
.supported_strength_event_types <- function() {
  c(
    'faceoff',
    'hit',
    'shot-on-goal',
    'giveaway',
    'missed-shot',
    'blocked-shot',
    'penalty',
    'goal',
    'delayed-penalty',
    'takeaway',
    'failed-shot-attempt'
  )
}

#' Return the number of on-ice skater slots
#'
#' `.on_ice_skater_slots()` returns the maximum number of skater slots tracked
#' per team in play-by-play outputs.
#'
#' @returns integer scalar
#' @keywords internal
.on_ice_skater_slots <- function() {
  6L
}

#' List on-ice player ID columns
#'
#' `.on_ice_id_scalar_column_names()` returns the public scalar goalie and
#' skater ID column names used in enriched play-by-play outputs.
#'
#' @returns character vector of on-ice player ID columns
#' @keywords internal
.on_ice_id_scalar_column_names <- function() {
  skater_slots <- seq_len(.on_ice_skater_slots())
  c(
    'homeGoaliePlayerId',
    'awayGoaliePlayerId',
    'goaliePlayerIdFor',
    'goaliePlayerIdAgainst',
    as.vector(rbind(
      paste0('homeSkater', skater_slots, 'PlayerId'),
      paste0('awaySkater', skater_slots, 'PlayerId'),
      paste0('skater', skater_slots, 'PlayerIdFor'),
      paste0('skater', skater_slots, 'PlayerIdAgainst')
    ))
  )
}

#' List all scalar on-ice columns
#'
#' `.on_ice_scalar_column_names()` returns the scalar on-ice player ID and
#' shift-timing columns used by the public play-by-play schema.
#'
#' @returns character vector of scalar on-ice columns
#' @keywords internal
.on_ice_scalar_column_names <- function() {
  c(
    .on_ice_id_scalar_column_names(),
    .on_ice_timing_scalar_column_names('SecondsElapsedInShift'),
    .on_ice_timing_scalar_column_names('SecondsElapsedInPeriodSinceLastShift')
  )
}

#' Initialize empty on-ice columns
#'
#' `.add_empty_html_on_ice_columns()` allocates empty scalar on-ice player ID
#' and timing columns before HTML and shift-chart enrichment.
#'
#' @param play_by_play data.frame play-by-play object
#' @returns data.frame with empty on-ice columns added
#' @keywords internal
.add_empty_html_on_ice_columns <- function(play_by_play) {
  id_cols <- .on_ice_id_scalar_column_names()
  time_cols <- setdiff(.on_ice_scalar_column_names(), id_cols)
  for (nm in id_cols) {
    play_by_play[[nm]] <- rep(NA_integer_, nrow(play_by_play))
  }
  for (nm in time_cols) {
    play_by_play[[nm]] <- rep(NA_real_, nrow(play_by_play))
  }
  play_by_play
}

#' Rebuild strength context from HTML on-ice players
#'
#' `.rebuild_strength_context_from_html()` reconstructs situation-code-derived
#' strength columns from resolved home and away on-ice goalie and skater IDs.
#'
#' @param play_by_play data.frame play-by-play object
#' @param idx row index to update
#' @param home_goalie resolved home goalie player ID
#' @param away_goalie resolved away goalie player ID
#' @param home_skaters integer vector of home skater IDs
#' @param away_skaters integer vector of away skater IDs
#' @returns data.frame with rebuilt strength context for the selected row
#' @keywords internal
.rebuild_strength_context_from_html <- function(
  play_by_play,
  idx,
  home_goalie,
  away_goalie,
  home_skaters,
  away_skaters
) {
  home_skater_count <- as.integer(length(home_skaters))
  away_skater_count <- as.integer(length(away_skaters))
  home_is_empty_net <- is.na(home_goalie)
  away_is_empty_net <- is.na(away_goalie)

  play_by_play$situationCode[idx] <- sprintf(
    '%d%d%d%d',
    if (away_is_empty_net) 0L else 1L,
    away_skater_count,
    home_skater_count,
    if (home_is_empty_net) 0L else 1L
  )
  play_by_play$homeIsEmptyNet[idx] <- home_is_empty_net
  play_by_play$awayIsEmptyNet[idx] <- away_is_empty_net
  play_by_play$homeSkaterCount[idx] <- home_skater_count
  play_by_play$awaySkaterCount[idx] <- away_skater_count

  if (play_by_play$isHome[idx] %in% TRUE) {
    skaters_for <- home_skater_count
    skaters_against <- away_skater_count
    empty_for <- home_is_empty_net
    empty_against <- away_is_empty_net
    men_for <- skaters_for + if (home_is_empty_net) 0L else 1L
    men_against <- skaters_against + if (away_is_empty_net) 0L else 1L
  } else if (play_by_play$isHome[idx] %in% FALSE) {
    skaters_for <- away_skater_count
    skaters_against <- home_skater_count
    empty_for <- away_is_empty_net
    empty_against <- home_is_empty_net
    men_for <- skaters_for + if (away_is_empty_net) 0L else 1L
    men_against <- skaters_against + if (home_is_empty_net) 0L else 1L
  } else {
    skaters_for <- NA_integer_
    skaters_against <- NA_integer_
    empty_for <- NA
    empty_against <- NA
    men_for <- NA_integer_
    men_against <- NA_integer_
  }

  play_by_play$isEmptyNetFor[idx] <- empty_for
  play_by_play$isEmptyNetAgainst[idx] <- empty_against
  play_by_play$skaterCountFor[idx] <- skaters_for
  play_by_play$skaterCountAgainst[idx] <- skaters_against
  play_by_play$manDifferential[idx] <- if (
    is.na(men_for) || is.na(men_against)
  ) {
    NA_integer_
  } else {
    men_for - men_against
  }
  play_by_play$strengthState[idx] <- if (is.na(play_by_play$manDifferential[idx])) {
    NA_character_
  } else if (play_by_play$manDifferential[idx] > 0L) {
    'power-play'
  } else if (play_by_play$manDifferential[idx] < 0L) {
    'penalty-kill'
  } else {
    'even-strength'
  }

  play_by_play
}

#' Mask strength-only columns on unsupported events
#'
#' `.mask_strength_context_block()` sets strength and on-ice columns to `NA` on
#' event types that are not supported by the HTML on-ice pipeline.
#'
#' @param play_by_play data.frame play-by-play object
#' @returns data.frame with unsupported rows masked
#' @keywords internal
.mask_strength_context_block <- function(play_by_play) {
  type_desc_key <- if ('typeDescKey' %in% names(play_by_play)) {
    as.character(play_by_play$typeDescKey)
  } else if ('eventTypeDescKey' %in% names(play_by_play)) {
    as.character(play_by_play$eventTypeDescKey)
  } else {
    rep(NA_character_, nrow(play_by_play))
  }
  supported <- !is.na(type_desc_key) &
    type_desc_key %in% .supported_strength_event_types()
  cols <- intersect(c(
    'situationCode',
    'homeIsEmptyNet',
    'awayIsEmptyNet',
    'isEmptyNetFor',
    'isEmptyNetAgainst',
    'homeSkaterCount',
    'awaySkaterCount',
    'skaterCountFor',
    'skaterCountAgainst',
    'manDifferential',
    'strengthState',
    .on_ice_scalar_column_names()
  ), names(play_by_play))
  for (nm in cols) {
    x <- play_by_play[[nm]]
    if (is.integer(x)) {
      x[!supported] <- NA_integer_
    } else if (is.numeric(x)) {
      x[!supported] <- NA_real_
    } else if (is.character(x)) {
      x[!supported] <- NA_character_
    } else if (is.logical(x)) {
      x[!supported] <- NA
    }
    play_by_play[[nm]] <- x
  }
  play_by_play
}

#' Normalize roster person labels
#'
#' `.normalize_roster_person()` standardizes roster names for stable matching by
#' uppercasing, trimming, collapsing whitespace, and transliterating accents.
#'
#' @param x character vector of player names
#' @returns normalized character vector
#' @keywords internal
.normalize_roster_person <- function(x) {
  x <- gsub('\\s+', ' ', x)
  x <- trimws(x)
  x <- toupper(x)
  x <- iconv(x, from = '', to = 'ASCII//TRANSLIT')
  x[is.na(x)] <- ''
  x
}

#' Build a game-roster lookup table
#'
#' `.build_game_roster_lookup()` standardizes roster columns and prepares a
#' lookup table used to resolve HTML sweater numbers to player IDs.
#'
#' @param rosters roster data.frame from the game play-by-play metadata
#' @returns standardized roster lookup data.frame
#' @keywords internal
.build_game_roster_lookup <- function(rosters) {
  if (is.null(rosters) || !nrow(rosters)) {
    return(data.frame())
  }
  rosters <- as.data.frame(rosters, stringsAsFactors = FALSE)
  if (!'playerId' %in% names(rosters) && 'id' %in% names(rosters)) {
    names(rosters)[names(rosters) == 'id'] <- 'playerId'
  }
  if (!'positionCode' %in% names(rosters) && 'position' %in% names(rosters)) {
    names(rosters)[names(rosters) == 'position'] <- 'positionCode'
  }
  if (!'playerLastName' %in% names(rosters) && 'lastName.default' %in% names(rosters)) {
    rosters$playerLastName <- rosters[['lastName.default']]
  }
  if (!'playerFirstName' %in% names(rosters) && 'firstName.default' %in% names(rosters)) {
    rosters$playerFirstName <- rosters[['firstName.default']]
  }
  rosters$sweaterNumber <- suppressWarnings(as.integer(rosters$sweaterNumber))
  rosters$playerLabel <- .normalize_roster_person(
    paste(rosters$playerLastName, rosters$playerFirstName, sep = ', ')
  )
  rosters
}

#' Resolve a roster player ID
#'
#' `.lookup_roster_player_id()` resolves a player ID from team, sweater number,
#' and optional name information within a roster lookup table.
#'
#' @param roster_lookup standardized roster lookup data.frame
#' @param team_id team ID
#' @param sweater_number sweater number
#' @param player_name optional player name
#' @returns integer player ID or `NA_integer_`
#' @keywords internal
.lookup_roster_player_id <- function(
  roster_lookup,
  team_id,
  sweater_number,
  player_name = NA_character_
) {
  if (!nrow(roster_lookup) || is.na(team_id)) {
    return(NA_integer_)
  }
  idx <- which(roster_lookup$teamId == team_id)
  if (!length(idx)) {
    return(NA_integer_)
  }
  if (!is.na(sweater_number)) {
    idx_num <- idx[roster_lookup$sweaterNumber[idx] == sweater_number]
    if (length(idx_num) == 1L) {
      return(as.integer(roster_lookup$playerId[idx_num]))
    }
    if (length(idx_num) > 1L && !is.na(player_name) && nzchar(player_name)) {
      target <- .normalize_roster_person(player_name)
      idx_name <- idx_num[roster_lookup$playerLabel[idx_num] == target]
      if (length(idx_name)) {
        return(as.integer(roster_lookup$playerId[idx_name[1L]]))
      }
    }
    if (length(idx_num)) {
      return(as.integer(roster_lookup$playerId[idx_num[1L]]))
    }
  }
  if (!is.na(player_name) && nzchar(player_name)) {
    target <- .normalize_roster_person(player_name)
    idx_name <- idx[roster_lookup$playerLabel[idx] == target]
    if (length(idx_name)) {
      return(as.integer(roster_lookup$playerId[idx_name[1L]]))
    }
  }
  NA_integer_
}

#' Parse an HTML period label
#'
#' `.parse_html_period_label()` converts HTML report period labels such as `OT`
#' and `SO` into integer period numbers.
#'
#' @param x HTML period label
#' @param is_playoffs logical; whether the game is a playoff game
#' @returns integer period number or `NA_integer_`
#' @keywords internal
.parse_html_period_label <- function(x, is_playoffs = FALSE) {
  x <- trimws(toupper(as.character(x)))
  if (!length(x) || is.na(x) || !nzchar(x)) {
    return(NA_integer_)
  }
  if (grepl('^[0-9]+$', x)) {
    return(as.integer(x))
  }
  if (x == 'OT') {
    return(4L)
  }
  if (grepl('^[0-9]+OT$', x)) {
    return(3L + as.integer(sub('OT$', '', x)))
  }
  if (x == 'SO') {
    return(if (is_playoffs) NA_integer_ else 5L)
  }
  NA_integer_
}

#' Parse an HTML elapsed clock
#'
#' `.parse_html_elapsed_clock()` extracts the elapsed `MM:SS` clock from an HTML
#' report time field and converts it to elapsed seconds in period.
#'
#' @param x HTML time field
#' @returns integer seconds elapsed in period or `NA_integer_`
#' @keywords internal
.parse_html_elapsed_clock <- function(x) {
  x <- trimws(as.character(x))
  if (!length(x) || is.na(x)) {
    return(NA_integer_)
  }
  m <- regexpr('^[0-9]{1,2}:[0-9]{2}', x)
  if (m[1] < 0L) {
    return(NA_integer_)
  }
  clock <- substr(x, m[1], m[1] + attr(m, 'match.length')[1] - 1L)
  parts <- strsplit(clock, ':', fixed = TRUE)[[1]]
  if (length(parts) != 2L) {
    return(NA_integer_)
  }
  mins <- suppressWarnings(as.integer(parts[1]))
  secs <- suppressWarnings(as.integer(parts[2]))
  if (is.na(mins) || is.na(secs)) {
    return(NA_integer_)
  }
  60L * mins + secs
}

#' Normalize an HTML team abbreviation
#'
#' `.normalize_html_team_abbrev()` uppercases and strips punctuation from HTML
#' team abbreviations so dotted legacy abbreviations still match.
#'
#' @param x character vector of team abbreviations
#' @returns normalized character vector
#' @keywords internal
.normalize_html_team_abbrev <- function(x) {
  x <- toupper(as.character(x))
  x <- gsub('[^A-Z]', '', x)
  x[is.na(x)] <- ''
  x
}

#' Map HTML event codes to event type keys
#'
#' `.html_event_code_to_type_desc()` converts HTML report event codes and select
#' description fallbacks into internal play-by-play event type keys.
#'
#' @param event_code HTML event code
#' @param description optional HTML event description
#' @returns event type key or `NA_character_`
#' @keywords internal
.html_event_code_to_type_desc <- function(event_code, description = NA_character_) {
  code_map <- c(
    FAC = 'faceoff',
    HIT = 'hit',
    SHOT = 'shot-on-goal',
    GIVE = 'giveaway',
    MISS = 'missed-shot',
    BLOCK = 'blocked-shot',
    PENL = 'penalty',
    GOAL = 'goal',
    TAKE = 'takeaway',
    DELPEN = 'delayed-penalty',
    DLPEN = 'delayed-penalty',
    DPEN = 'delayed-penalty'
  )
  event_code <- trimws(toupper(as.character(event_code)))
  out <- unname(code_map[event_code])
  if (!is.na(out)) {
    return(out)
  }
  desc <- trimws(toupper(as.character(description)))
  if (grepl('DELAYED PENALTY', desc, fixed = TRUE)) {
    return('delayed-penalty')
  }
  if (grepl('FAILED SHOT ATTEMPT', desc, fixed = TRUE)) {
    return('failed-shot-attempt')
  }
  NA_character_
}

#' Resolve the owner team from an HTML description
#'
#' `.html_desc_owner_team_id()` infers the event owner team ID from the leading
#' team abbreviation embedded in an HTML event description.
#'
#' @param description HTML event description
#' @param home_abbrev home-team abbreviation
#' @param away_abbrev away-team abbreviation
#' @param home_team_id home-team ID
#' @param away_team_id away-team ID
#' @returns integer team ID or `NA_integer_`
#' @keywords internal
.html_desc_owner_team_id <- function(
  description,
  home_abbrev,
  away_abbrev,
  home_team_id,
  away_team_id
) {
  desc <- trimws(toupper(as.character(description)))
  m <- regexpr('^[A-Z.]{2,4}', desc)
  if (m[1] < 0L) {
    return(NA_integer_)
  }
  team <- .normalize_html_team_abbrev(
    substr(desc, m[1], m[1] + attr(m, 'match.length')[1] - 1L)
  )
  home_norm <- .normalize_html_team_abbrev(home_abbrev)
  away_norm <- .normalize_html_team_abbrev(away_abbrev)
  if (
    nzchar(home_norm) &&
      (team == home_norm || startsWith(home_norm, team) || startsWith(team, home_norm))
  ) {
    return(as.integer(home_team_id))
  }
  if (
    nzchar(away_norm) &&
      (team == away_norm || startsWith(away_norm, team) || startsWith(team, away_norm))
  ) {
    return(as.integer(away_team_id))
  }
  NA_integer_
}

#' Extract actor player IDs from an HTML event
#'
#' `.html_extract_actor_player_ids()` resolves primary, secondary, and tertiary
#' actor player IDs from HTML event descriptions using the roster lookup.
#'
#' @param description HTML event description
#' @param type_desc_key internal event type key
#' @param owner_team_id owner team ID
#' @param home_team_id home-team ID
#' @param away_team_id away-team ID
#' @param roster_lookup standardized roster lookup data.frame
#' @returns named list of actor player IDs
#' @keywords internal
.html_extract_actor_player_ids <- function(
  description,
  type_desc_key,
  owner_team_id,
  home_team_id,
  away_team_id,
  roster_lookup
) {
  nums_raw <- regmatches(
    description,
    gregexpr('#[0-9]{1,2}', description, perl = TRUE)
  )[[1]]
  sweaters <- suppressWarnings(as.integer(sub('^#', '', nums_raw)))
  opponent_team_id <- if (!is.na(owner_team_id)) {
    if (owner_team_id == home_team_id) {
      away_team_id
    } else if (owner_team_id == away_team_id) {
      home_team_id
    } else {
      NA_integer_
    }
  } else {
    NA_integer_
  }
  owner_pick <- function(pos) {
    if (length(sweaters) < pos || is.na(owner_team_id)) {
      return(NA_integer_)
    }
    .lookup_roster_player_id(roster_lookup, owner_team_id, sweaters[pos])
  }
  opp_pick <- function(pos) {
    if (length(sweaters) < pos || is.na(opponent_team_id)) {
      return(NA_integer_)
    }
    .lookup_roster_player_id(roster_lookup, opponent_team_id, sweaters[pos])
  }
  primary <- secondary <- tertiary <- NA_integer_
  if (is.na(type_desc_key)) {
    return(list(primaryPlayerId = primary, secondaryPlayerId = secondary, tertiaryPlayerId = tertiary))
  }
  switch(
    type_desc_key,
    faceoff = {
      primary <- owner_pick(1L)
      secondary <- opp_pick(2L)
    },
    hit = {
      primary <- owner_pick(1L)
      secondary <- opp_pick(2L)
    },
    `shot-on-goal` = {
      primary <- owner_pick(1L)
    },
    `missed-shot` = {
      primary <- owner_pick(1L)
    },
    `failed-shot-attempt` = {
      primary <- owner_pick(1L)
    },
    `blocked-shot` = {
      primary <- owner_pick(1L)
      secondary <- opp_pick(2L)
    },
    penalty = {
      primary <- owner_pick(1L)
      secondary <- opp_pick(2L)
    },
    `delayed-penalty` = {
      primary <- owner_pick(1L)
      secondary <- opp_pick(2L)
    },
    goal = {
      primary <- owner_pick(1L)
      secondary <- owner_pick(2L)
      tertiary <- owner_pick(3L)
    },
    giveaway = {
      primary <- owner_pick(1L)
    },
    takeaway = {
      primary <- owner_pick(1L)
    }
  )
  list(
    primaryPlayerId = as.integer(primary),
    secondaryPlayerId = as.integer(secondary),
    tertiaryPlayerId = as.integer(tertiary)
  )
}

#' Parse an HTML on-ice cell
#'
#' `.parse_html_on_ice_cell()` resolves a goalie and skater player-ID list from
#' a single team on-ice HTML cell.
#'
#' @param text on-ice cell text
#' @param team_id team ID for the cell
#' @param roster_lookup standardized roster lookup data.frame
#' @returns named list containing goalie and skater player IDs
#' @keywords internal
.parse_html_on_ice_cell <- function(text, team_id, roster_lookup) {
  txt <- gsub('\u00A0', ' ', as.character(text), fixed = TRUE)
  txt <- gsub('\\s+', ' ', txt)
  txt <- trimws(txt)
  if (!nzchar(txt)) {
    return(list(goaliePlayerId = NA_integer_, skaterPlayerIds = integer()))
  }
  tokens <- regmatches(txt, gregexpr('([0-9]{1,2})\\s+([A-Z]{1,3})', txt, perl = TRUE))[[1]]
  if (!length(tokens)) {
    return(list(goaliePlayerId = NA_integer_, skaterPlayerIds = integer()))
  }
  sweaters <- suppressWarnings(as.integer(sub('\\s+.*$', '', tokens)))
  pos <- sub('^[0-9]{1,2}\\s+', '', tokens)
  player_ids <- vapply(
    sweaters,
    function(sw) .lookup_roster_player_id(roster_lookup, team_id, sw),
    integer(1)
  )
  goalie_idx <- which(pos == 'G')
  goalie_id <- if (length(goalie_idx)) player_ids[goalie_idx[1L]] else NA_integer_
  skater_ids <- player_ids[setdiff(seq_along(player_ids), goalie_idx)]
  list(
    goaliePlayerId = as.integer(goalie_id),
    skaterPlayerIds = as.integer(skater_ids)
  )
}

#' Parse an HTML play-by-play document
#'
#' `.parse_html_pbp_doc()` extracts event rows, actor IDs, and on-ice player
#' lists from an NHL HTML play-by-play report.
#'
#' @param doc parsed HTML document
#' @param roster_lookup standardized roster lookup data.frame
#' @param home_team_id home-team ID
#' @param away_team_id away-team ID
#' @param home_abbrev home-team abbreviation
#' @param away_abbrev away-team abbreviation
#' @param is_playoffs logical; whether the game is a playoff game
#' @returns data.frame of parsed HTML play-by-play rows
#' @keywords internal
.parse_html_pbp_doc <- function(
  doc,
  roster_lookup,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev,
  is_playoffs = FALSE
) {
  rows <- xml2::xml_find_all(doc, './/tr')
  out <- vector('list', length(rows))
  n_out <- 0L
  for (row in rows) {
    cells <- xml2::xml_find_all(row, './th|./td')
    if (length(cells) < 8L) {
      next
    }
    txt <- xml2::xml_text(cells, trim = TRUE)
    txt <- gsub('\u00A0', ' ', txt, fixed = TRUE)
    txt <- trimws(txt)
    if (!length(txt) || !grepl('^[0-9]+$', txt[1])) {
      next
    }
    period_number <- .parse_html_period_label(txt[2], is_playoffs = is_playoffs)
    event_code <- trimws(toupper(txt[5]))
    description <- txt[6]
    type_desc_key <- .html_event_code_to_type_desc(event_code, description)
    owner_team_id <- .html_desc_owner_team_id(
      description,
      home_abbrev = home_abbrev,
      away_abbrev = away_abbrev,
      home_team_id = home_team_id,
      away_team_id = away_team_id
    )
    actors <- .html_extract_actor_player_ids(
      description = description,
      type_desc_key = type_desc_key,
      owner_team_id = owner_team_id,
      home_team_id = home_team_id,
      away_team_id = away_team_id,
      roster_lookup = roster_lookup
    )
    away_on_ice <- .parse_html_on_ice_cell(
      txt[length(txt) - 1L],
      team_id = away_team_id,
      roster_lookup = roster_lookup
    )
    home_on_ice <- .parse_html_on_ice_cell(
      txt[length(txt)],
      team_id = home_team_id,
      roster_lookup = roster_lookup
    )
    n_out <- n_out + 1L
    out[[n_out]] <- data.frame(
      htmlEventNumber = suppressWarnings(as.integer(txt[1])),
      period = as.integer(period_number),
      strengthCodeHtml = trimws(txt[3]),
      secondsElapsedInPeriod = .parse_html_elapsed_clock(txt[4]),
      htmlEventCode = event_code,
      typeDescKey = type_desc_key,
      description = description,
      ownerTeamId = as.integer(owner_team_id),
      primaryPlayerId = actors$primaryPlayerId,
      secondaryPlayerId = actors$secondaryPlayerId,
      tertiaryPlayerId = actors$tertiaryPlayerId,
      homeGoaliePlayerId = home_on_ice$goaliePlayerId,
      awayGoaliePlayerId = away_on_ice$goaliePlayerId,
      stringsAsFactors = FALSE
    )
    out[[n_out]]$homeSkaterPlayerIds <- list(home_on_ice$skaterPlayerIds)
    out[[n_out]]$awaySkaterPlayerIds <- list(away_on_ice$skaterPlayerIds)
  }
  if (!n_out) {
    return(data.frame())
  }
  out <- do.call(rbind, out[seq_len(n_out)])
  out[order(out$period, out$secondsElapsedInPeriod, out$htmlEventNumber), ]
}

#' Fetch HTML on-ice play-by-play rows
#'
#' `.fetch_html_pbp_on_ice()` downloads an NHL HTML play-by-play report and
#' parses its on-ice content into a structured data frame.
#'
#' @param game game ID
#' @param rosters roster data.frame from play-by-play metadata
#' @param home_team_id home-team ID
#' @param away_team_id away-team ID
#' @param home_abbrev home-team abbreviation
#' @param away_abbrev away-team abbreviation
#' @returns data.frame of parsed HTML play-by-play rows
#' @keywords internal
.fetch_html_pbp_on_ice <- function(
  game,
  rosters,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev
) {
  season <- paste0(game %/% 1e6, game %/% 1e6 + 1L)
  game_code <- sprintf('%06d', game %% 10^6)
  url <- sprintf(
    'https://www.nhl.com/scores/htmlreports/%s/PL%s.HTM',
    season,
    game_code
  )
  doc <- xml2::read_html(url)
  .parse_html_pbp_doc(
    doc = doc,
    roster_lookup = .build_game_roster_lookup(rosters),
    home_team_id = as.integer(home_team_id),
    away_team_id = as.integer(away_team_id),
    home_abbrev = home_abbrev,
    away_abbrev = away_abbrev,
    is_playoffs = game %/% 1e4 %% 1e2 == 3L
  )
}

#' Build API-side HTML matching features
#'
#' `.build_api_html_match_table()` derives the API-side matching features used
#' to align HTML play-by-play rows back to API play-by-play rows.
#'
#' @param play_by_play data.frame play-by-play object
#' @returns data.frame of API-side matching features
#' @keywords internal
.build_api_html_match_table <- function(play_by_play) {
  play_by_play <- .pbp_legacy_aliases(play_by_play)
  n <- nrow(play_by_play)
  out <- data.frame(
    apiIndex = seq_len(n),
    apiSeq = seq_len(n),
    period = as.integer(play_by_play$period),
    secondsElapsedInPeriod = as.integer(play_by_play$secondsElapsedInPeriod),
    typeDescKey = as.character(play_by_play$typeDescKey),
    ownerTeamId = as.integer(play_by_play$eventOwnerTeamId),
    situationCode = as.character(play_by_play$situationCode),
    primaryPlayerId = rep(NA_integer_, n),
    secondaryPlayerId = rep(NA_integer_, n),
    tertiaryPlayerId = rep(NA_integer_, n),
    stringsAsFactors = FALSE
  )
  for (i in seq_len(n)) {
    type_desc_key <- out$typeDescKey[i]
    if (is.na(type_desc_key)) {
      next
    }
    if (type_desc_key == 'faceoff') {
      out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'winningPlayerId')[i]
      out$secondaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'losingPlayerId')[i]
    } else if (type_desc_key == 'hit') {
      out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'hittingPlayerId')[i]
      out$secondaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'hitteePlayerId')[i]
    } else if (type_desc_key %in% c('shot-on-goal', 'missed-shot', 'failed-shot-attempt')) {
      shooter <- .on_ice_int_col(play_by_play, 'shootingPlayerId')[i]
      scorer <- .on_ice_int_col(play_by_play, 'scoringPlayerId')[i]
      out$primaryPlayerId[i] <- ifelse(!is.na(scorer), scorer, shooter)
    } else if (type_desc_key == 'blocked-shot') {
      out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'shootingPlayerId')[i]
      out$secondaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'blockingPlayerId')[i]
    } else if (type_desc_key == 'penalty' || type_desc_key == 'delayed-penalty') {
      out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'committedByPlayerId')[i]
      if (is.na(out$primaryPlayerId[i])) {
        out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'playerId')[i]
      }
      out$secondaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'drawnByPlayerId')[i]
    } else if (type_desc_key == 'goal') {
      out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'scoringPlayerId')[i]
      if (is.na(out$primaryPlayerId[i])) {
        out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'shootingPlayerId')[i]
      }
      out$secondaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'assist1PlayerId')[i]
      out$tertiaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'assist2PlayerId')[i]
    } else if (type_desc_key %in% c('giveaway', 'takeaway')) {
      out$primaryPlayerId[i] <- .on_ice_int_col(play_by_play, 'playerId')[i]
    }
  }
  out <- out[out$typeDescKey %in% .supported_strength_event_types(), , drop = FALSE]
  out$apiSeq <- seq_len(nrow(out))
  out
}

#' Score HTML-to-API matching candidates
#'
#' `.score_html_api_candidates()` scores candidate API rows for a single HTML
#' row using time, type, team, player, and local sequence agreement.
#'
#' @param api API-side matching table
#' @param html HTML-side matching table
#' @param cand integer candidate API indices
#' @param h_idx HTML row index being scored
#' @param last_api_seq optional last matched API sequence number
#' @returns named numeric vector of candidate scores
#' @keywords internal
.score_html_api_candidates <- function(api, html, cand, h_idx, last_api_seq = NULL) {
  if (!length(cand)) {
    return(stats::setNames(numeric(), character()))
  }
  sec_diff <- abs(api$secondsElapsedInPeriod[cand] - html$secondsElapsedInPeriod[h_idx])
  if (any(sec_diff == 0L, na.rm = TRUE)) {
    cand <- cand[sec_diff == 0L]
    sec_diff <- sec_diff[sec_diff == 0L]
  } else if (any(sec_diff <= 1L, na.rm = TRUE)) {
    cand <- cand[sec_diff <= 1L]
    sec_diff <- sec_diff[sec_diff <= 1L]
  } else if (any(sec_diff <= 2L, na.rm = TRUE)) {
    cand <- cand[sec_diff <= 2L]
    sec_diff <- sec_diff[sec_diff <= 2L]
  } else {
    return(stats::setNames(numeric(), character()))
  }
  scores <- rep(0, length(cand))
  scores <- scores + ifelse(sec_diff == 0L, 500, ifelse(sec_diff <= 1L, 300, 150))
  exact_type <- api$typeDescKey[cand] == html$typeDescKey[h_idx]
  scores <- scores + ifelse(exact_type, 250, 180)
  if (!is.na(html$ownerTeamId[h_idx])) {
    scores <- scores + ifelse(api$ownerTeamId[cand] == html$ownerTeamId[h_idx], 140, -40)
  }
  if (!is.na(html$primaryPlayerId[h_idx])) {
    scores <- scores + ifelse(api$primaryPlayerId[cand] == html$primaryPlayerId[h_idx], 160, 0)
  }
  if (!is.na(html$secondaryPlayerId[h_idx])) {
    scores <- scores + ifelse(api$secondaryPlayerId[cand] == html$secondaryPlayerId[h_idx], 100, 0)
  }
  if (!is.na(html$tertiaryPlayerId[h_idx])) {
    scores <- scores + ifelse(api$tertiaryPlayerId[cand] == html$tertiaryPlayerId[h_idx], 50, 0)
  }
  scores <- scores - 8 * abs(api$apiSeq[cand] - html$htmlSeq[h_idx])
  if (!is.null(last_api_seq) && !is.na(last_api_seq)) {
    scores <- scores - 75 * pmax(0L, last_api_seq - api$apiSeq[cand])
  }
  names(scores) <- as.character(cand)
  scores
}

#' Match HTML play-by-play rows to API rows
#'
#' `.match_html_pbp_to_api()` aligns parsed HTML play-by-play rows back to API
#' play-by-play rows using exact keys, greedy scoring, and a reciprocal-best
#' fallback for duplicate clusters.
#'
#' @param play_by_play data.frame API play-by-play object
#' @param html_rows data.frame parsed HTML play-by-play rows
#' @returns data.frame of matched HTML rows with `apiIndex`
#' @keywords internal
.match_html_pbp_to_api <- function(play_by_play, html_rows) {
  api <- .build_api_html_match_table(play_by_play)
  if (!nrow(api) || is.null(html_rows) || !nrow(html_rows)) {
    return(data.frame())
  }
  html <- html_rows[html_rows$typeDescKey %in% .supported_strength_event_types(), , drop = FALSE]
  if (!nrow(html)) {
    return(data.frame())
  }
  html$htmlSeq <- seq_len(nrow(html))
  html$apiIndex <- NA_integer_
  api_taken <- rep(FALSE, nrow(api))

  html_key <- paste(
    html$period,
    html$secondsElapsedInPeriod,
    html$typeDescKey,
    ifelse(is.na(html$ownerTeamId), 'NA', html$ownerTeamId),
    sep = '|'
  )
  api_key <- paste(
    api$period,
    api$secondsElapsedInPeriod,
    api$typeDescKey,
    ifelse(is.na(api$ownerTeamId), 'NA', api$ownerTeamId),
    sep = '|'
  )
  for (key in intersect(unique(html_key), unique(api_key))) {
    h_idx <- which(is.na(html$apiIndex) & html_key == key)
    a_idx <- which(!api_taken & api_key == key)
    if (length(h_idx) == 1L && length(a_idx) == 1L) {
      html$apiIndex[h_idx] <- api$apiIndex[a_idx]
      api_taken[a_idx] <- TRUE
    }
  }

  last_api_seq <- 0L
  for (h_idx in which(is.na(html$apiIndex))) {
    cand <- which(
      !api_taken &
        api$period == html$period[h_idx] &
        (
          api$typeDescKey == html$typeDescKey[h_idx] |
            (
              api$typeDescKey == 'failed-shot-attempt' &
                html$typeDescKey[h_idx] %in% c('shot-on-goal', 'missed-shot', 'goal')
            )
        )
    )
    if (!length(cand)) {
      next
    }
    scores <- .score_html_api_candidates(api, html, cand, h_idx, last_api_seq = last_api_seq)
    if (!length(scores) || !any(is.finite(scores))) {
      next
    }
    cand <- as.integer(names(scores))
    best_pos <- which.max(scores)
    if (length(best_pos) && is.finite(scores[best_pos]) && scores[best_pos] >= 180) {
      html$apiIndex[h_idx] <- api$apiIndex[cand[best_pos]]
      api_taken[cand[best_pos]] <- TRUE
      last_api_seq <- api$apiSeq[cand[best_pos]]
    }
  }

  unmatched_html <- which(is.na(html$apiIndex))
  unmatched_api <- which(!api_taken)
  if (length(unmatched_html) && length(unmatched_api)) {
    html_best <- rep(NA_integer_, length(unmatched_html))
    html_best_score <- rep(-Inf, length(unmatched_html))
    for (i in seq_along(unmatched_html)) {
      h_idx <- unmatched_html[i]
      cand <- unmatched_api[
        api$period[unmatched_api] == html$period[h_idx] &
          (
            api$typeDescKey[unmatched_api] == html$typeDescKey[h_idx] |
              (
                api$typeDescKey[unmatched_api] == 'failed-shot-attempt' &
                  html$typeDescKey[h_idx] %in% c('shot-on-goal', 'missed-shot', 'goal')
              )
          )
      ]
      scores <- .score_html_api_candidates(api, html, cand, h_idx)
      if (!length(scores) || !any(is.finite(scores))) {
        next
      }
      best_pos <- which.max(scores)
      html_best[i] <- as.integer(names(scores)[best_pos])
      html_best_score[i] <- scores[best_pos]
    }

    api_best <- rep(NA_integer_, length(unmatched_api))
    api_best_score <- rep(-Inf, length(unmatched_api))
    for (i in seq_along(unmatched_api)) {
      a_idx <- unmatched_api[i]
      cand <- unmatched_html[
        html$period[unmatched_html] == api$period[a_idx] &
          (
            api$typeDescKey[a_idx] == html$typeDescKey[unmatched_html] |
              (
                api$typeDescKey[a_idx] == 'failed-shot-attempt' &
                  html$typeDescKey[unmatched_html] %in% c('shot-on-goal', 'missed-shot', 'goal')
              )
          )
      ]
      if (!length(cand)) {
        next
      }
      scores <- vapply(
        cand,
        function(h_idx) {
          out <- .score_html_api_candidates(api, html, a_idx, h_idx)
          if (!length(out)) {
            return(-Inf)
          }
          unname(out[[1L]])
        },
        numeric(1)
      )
      if (!any(is.finite(scores))) {
        next
      }
      best_pos <- which.max(scores)
      api_best[i] <- cand[best_pos]
      api_best_score[i] <- scores[best_pos]
    }

    for (i in seq_along(unmatched_html)) {
      h_idx <- unmatched_html[i]
      a_idx <- html_best[i]
      if (is.na(a_idx) || html_best_score[i] < 180) {
        next
      }
      api_slot <- match(a_idx, unmatched_api)
      if (is.na(api_slot) || is.na(api_best[api_slot])) {
        next
      }
      if (api_best[api_slot] != h_idx || api_best_score[api_slot] < 180) {
        next
      }
      html$apiIndex[h_idx] <- api$apiIndex[a_idx]
      api_taken[a_idx] <- TRUE
    }
  }

  html[!is.na(html$apiIndex), , drop = FALSE]
}

#' Add HTML-derived on-ice players to play-by-play
#'
#' `.add_html_on_ice_players()` resolves HTML on-ice goalie and skater IDs,
#' matches them to API rows, and injects the resulting scalar on-ice columns
#' into play-by-play output.
#'
#' @param play_by_play data.frame play-by-play object
#' @param game game ID
#' @param rosters optional roster data.frame
#' @param home_team optional home-team metadata
#' @param away_team optional away-team metadata
#' @returns data.frame enriched with HTML-derived on-ice columns
#' @keywords internal
.add_html_on_ice_players <- function(
  play_by_play,
  game,
  rosters = NULL,
  home_team = NULL,
  away_team = NULL
) {
  play_by_play <- .pbp_legacy_aliases(play_by_play)
  play_by_play <- .add_empty_html_on_ice_columns(play_by_play)
  if (!nrow(play_by_play)) {
    return(play_by_play)
  }
  if (is.null(rosters) || is.null(home_team) || is.null(away_team)) {
    meta <- nhl_api(
      path = sprintf('v1/gamecenter/%s/play-by-play', as.integer(game)),
      type = 'w'
    )
    if (is.null(rosters)) {
      rosters <- meta$rosterSpots
    }
    if (is.null(home_team)) {
      home_team <- meta$homeTeam
    }
    if (is.null(away_team)) {
      away_team <- meta$awayTeam
    }
  }
  html_rows <- tryCatch(
    .fetch_html_pbp_on_ice(
      game = as.integer(game),
      rosters = rosters,
      home_team_id = home_team$id,
      away_team_id = away_team$id,
      home_abbrev = home_team$abbrev,
      away_abbrev = away_team$abbrev
    ),
    error = function(e) data.frame()
  )
  matched <- .match_html_pbp_to_api(play_by_play, html_rows)
  if (!nrow(matched)) {
    return(.mask_strength_context_block(play_by_play))
  }
  for (i in seq_len(nrow(matched))) {
    idx <- matched$apiIndex[i]
    home_goalie <- as.integer(matched$homeGoaliePlayerId[i])
    away_goalie <- as.integer(matched$awayGoaliePlayerId[i])
    home_skaters <- unlist(matched$homeSkaterPlayerIds[i], use.names = FALSE)
    away_skaters <- unlist(matched$awaySkaterPlayerIds[i], use.names = FALSE)
    slot_count <- .on_ice_skater_slots()
    home_slots <- rep(NA_integer_, slot_count)
    away_slots <- rep(NA_integer_, slot_count)
    if (length(home_skaters)) {
      home_slots[seq_len(min(slot_count, length(home_skaters)))] <- home_skaters[seq_len(min(slot_count, length(home_skaters)))]
    }
    if (length(away_skaters)) {
      away_slots[seq_len(min(slot_count, length(away_skaters)))] <- away_skaters[seq_len(min(slot_count, length(away_skaters)))]
    }
    play_by_play <- .rebuild_strength_context_from_html(
      play_by_play = play_by_play,
      idx = idx,
      home_goalie = home_goalie,
      away_goalie = away_goalie,
      home_skaters = home_skaters,
      away_skaters = away_skaters
    )
    play_by_play$homeGoaliePlayerId[idx] <- home_goalie
    play_by_play$awayGoaliePlayerId[idx] <- away_goalie
    for (k in seq_len(slot_count)) {
      play_by_play[[paste0('homeSkater', k, 'PlayerId')]][idx] <- home_slots[k]
      play_by_play[[paste0('awaySkater', k, 'PlayerId')]][idx] <- away_slots[k]
    }
    if (play_by_play$isHome[idx] %in% TRUE) {
      play_by_play$goaliePlayerIdFor[idx] <- home_goalie
      play_by_play$goaliePlayerIdAgainst[idx] <- away_goalie
      for (k in seq_len(slot_count)) {
        play_by_play[[paste0('skater', k, 'PlayerIdFor')]][idx] <- home_slots[k]
        play_by_play[[paste0('skater', k, 'PlayerIdAgainst')]][idx] <- away_slots[k]
      }
    } else if (play_by_play$isHome[idx] %in% FALSE) {
      play_by_play$goaliePlayerIdFor[idx] <- away_goalie
      play_by_play$goaliePlayerIdAgainst[idx] <- home_goalie
      for (k in seq_len(slot_count)) {
        play_by_play[[paste0('skater', k, 'PlayerIdFor')]][idx] <- away_slots[k]
        play_by_play[[paste0('skater', k, 'PlayerIdAgainst')]][idx] <- home_slots[k]
      }
    }
  }
  .mask_strength_context_block(play_by_play)
}

#' Finalize public play-by-play output
#'
#' `.finalize_pbp_output()` renames internal columns to the public schema and
#' selects the final GC or WSC play-by-play column set.
#'
#' @param play_by_play data.frame play-by-play object
#' @param source output source, either `"gc"` or `"wsc"`
#' @returns data.frame with the finalized public play-by-play schema
#' @keywords internal
.finalize_pbp_output <- function(play_by_play, source = c('gc', 'wsc')) {
  source <- match.arg(source)
  play_by_play <- .pbp_legacy_aliases(play_by_play)
  on_ice_cols <- .on_ice_scalar_column_names()

  if (all(c('typeDescKey', 'shootingPlayerId', 'scoringPlayerId') %in% names(play_by_play))) {
    goal_idx <- play_by_play$typeDescKey == 'goal' &
      is.na(play_by_play$shootingPlayerId) &
      !is.na(play_by_play$scoringPlayerId)
    play_by_play$shootingPlayerId[goal_idx] <- play_by_play$scoringPlayerId[goal_idx]
  }

  rename_to_public <- c(
    period = 'periodNumber',
    typeCode = 'eventTypeCode',
    typeDescKey = 'eventTypeDescKey',
    homeSOG = 'homeShots',
    awaySOG = 'awayShots',
    SOGFor = 'shotsFor',
    SOGAgainst = 'shotsAgainst',
    SOGDifferential = 'shotDifferential',
    descKey = 'penaltyTypeDescKey',
    duration = 'penaltyDuration'
  )

  for (old in names(rename_to_public)) {
    new <- rename_to_public[[old]]
    if (old %in% names(play_by_play)) {
      if (new %in% names(play_by_play)) {
        fill <- is.na(play_by_play[[new]])
        play_by_play[[new]][fill] <- play_by_play[[old]][fill]
        play_by_play[[old]] <- NULL
      } else {
        names(play_by_play)[names(play_by_play) == old] <- new
      }
    }
  }

  gc_cols <- c(
    'gameId', 'eventId', 'seasonId', 'gameTypeId', 'gameNumber', 'sortOrder',
    'periodNumber', 'periodType', 'secondsElapsedInPeriod',
    'secondsElapsedInGame', 'eventOwnerTeamId', 'isHome', 'eventTypeCode',
    'eventTypeDescKey', 'situationCode', 'homeIsEmptyNet', 'awayIsEmptyNet',
    'isEmptyNetFor', 'isEmptyNetAgainst', 'homeSkaterCount',
    'awaySkaterCount', 'skaterCountFor', 'skaterCountAgainst',
    'manDifferential', 'strengthState', on_ice_cols, 'homeTeamDefendingSide', 'zoneCode',
    'xCoord', 'yCoord', 'xCoordNorm', 'yCoordNorm', 'distance', 'angle',
    'shotType', 'isRush', 'isRebound', 'createdRebound', 'homeGoals',
    'awayGoals', 'goalsFor', 'goalsAgainst', 'homeShots', 'awayShots',
    'shotsFor', 'shotsAgainst', 'homeFenwick', 'awayFenwick', 'fenwickFor',
    'fenwickAgainst', 'homeCorsi', 'awayCorsi', 'corsiFor', 'corsiAgainst',
    'goalDifferential', 'shotDifferential', 'fenwickDifferential',
    'corsiDifferential', 'playerId', 'winningPlayerId', 'losingPlayerId',
    'hittingPlayerId', 'hitteePlayerId', 'committedByPlayerId',
    'drawnByPlayerId', 'blockingPlayerId', 'shootingPlayerId',
    'scoringPlayerId', 'assist1PlayerId', 'assist2PlayerId',
    'scoringPlayerTotal', 'assist1PlayerTotal', 'assist2PlayerTotal',
    'penaltyTypeCode', 'penaltyTypeDescKey', 'penaltyDuration', 'reason',
    'secondaryReason', 'discreteClip', 'highlightClip',
    'highlightClipSharingUrl', 'pptReplayUrl'
  )
  wsc_cols <- c(
    'gameId', 'eventId', 'seasonId', 'gameTypeId', 'gameNumber', 'sortOrder',
    'periodNumber', 'secondsElapsedInPeriod', 'secondsElapsedInGame', 'utc',
    'eventOwnerTeamId', 'isHome', 'eventTypeCode', 'eventTypeDescKey',
    'situationCode', 'homeIsEmptyNet', 'awayIsEmptyNet', 'isEmptyNetFor',
    'isEmptyNetAgainst', 'homeSkaterCount', 'awaySkaterCount',
    'skaterCountFor', 'skaterCountAgainst', 'manDifferential',
    'strengthState', on_ice_cols, 'homeTeamDefendingSide', 'zoneCode', 'xCoord', 'yCoord',
    'xCoordNorm', 'yCoordNorm', 'distance', 'angle', 'shotType', 'isRush',
    'isRebound', 'createdRebound', 'homeGoals', 'awayGoals', 'goalsFor',
    'goalsAgainst', 'homeShots', 'awayShots', 'shotsFor', 'shotsAgainst',
    'homeFenwick', 'awayFenwick', 'fenwickFor', 'fenwickAgainst',
    'homeCorsi', 'awayCorsi', 'corsiFor', 'corsiAgainst',
    'goalDifferential', 'shotDifferential', 'fenwickDifferential',
    'corsiDifferential', 'playerId', 'winningPlayerId', 'losingPlayerId',
    'hittingPlayerId', 'hitteePlayerId', 'committedByPlayerId',
    'drawnByPlayerId', 'blockingPlayerId', 'shootingPlayerId',
    'scoringPlayerId', 'assist1PlayerId', 'assist2PlayerId',
    'scoringPlayerTotal', 'assist1PlayerTotal', 'assist2PlayerTotal',
    'penaltyTypeCode', 'penaltyTypeDescKey', 'penaltyDuration', 'reason'
  )

  keep <- switch(source, gc = gc_cols, wsc = wsc_cols)
  play_by_play[, intersect(keep, names(play_by_play)), drop = FALSE]
}

#' Access the GameCenter (GC) play-by-play for a game
#'
#' `gc_play_by_play()` retrieves the GameCenter (GC) play-by-play for a game as
#' a `data.frame` where each row represents an event. The returned schema is the
#' cleaned, public-facing play-by-play schema, including canonical names such as
#' `periodNumber`, `eventTypeCode`, `eventTypeDescKey`, `homeShots`,
#' `shotsFor`, `penaltyTypeDescKey`, `penaltyDuration`, and HTML-report-derived
#' on-ice player ID columns such as `homeGoaliePlayerId`,
#' `awayGoaliePlayerId`, `homeSkater1PlayerId`, and `homeSkater6PlayerId`,
#' plus shift-chart-derived timing columns such as
#' `homeSkater1SecondsElapsedInShift` and
#' `homeSkater1SecondsElapsedInPeriodSinceLastShift`.
#'
#' @inheritParams gc_summary
#'
#' @returns data.frame with one row per event (play)
#' @examples
#' gc_pbp_Martin_Necas_legacy_game <- gc_play_by_play(game = 2025020275)
#' @export

gc_play_by_play <- function(game = 2023030417) {
  tryCatch(
    expr  = {
      game <- as.integer(game)
      pbp_meta <- nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )
      plays <- pbp_meta$plays
      # Rename columns.
      plays$gameId <- game
      plays        <- plays[, c('gameId', setdiff(names(plays), 'gameId'))]
      nms <- names(plays)
      nms[nms == 'details.typeCode'] <- 'penaltyTypeCode'
      idx          <- grepl('\\.', nms)
      nms[idx]     <- sub('^[^.]*\\.', '', nms[idx])
      nms[nms == 'number'] <- 'period'
      names(plays) <- nms
      if (
        all(c('typeDescKey', 'shootingPlayerId', 'scoringPlayerId') %in% names(plays))
      ) {
        goal_idx <- plays$typeDescKey == 'goal' &
          is.na(plays$shootingPlayerId) &
          !is.na(plays$scoringPlayerId)
        plays$shootingPlayerId[goal_idx] <- plays$scoringPlayerId[goal_idx]
      }
      # Fix zoneCode for blocked shots.
      idx <- plays$typeDescKey == 'blocked-shot' &
        plays$zoneCode %in% c('O', 'D')
      plays$zoneCode[idx] <- ifelse(
        plays$zoneCode[idx] == 'O',
        'D',
        'O'
      )
      # Remove inconsistent columns.
      plays$timeRemaining <- NULL
      # Clean.
      plays <- .strip_game_id(plays) |>
        .strip_time_period() |>
        .drop_illogical_ordered_events() |>
        .flag_is_home() |>
        .strip_situation_code() |>
        .normalize_coordinates() |>
        .calculate_distance() |>
        .calculate_angle() |>
        .apply_shot_context() |>
        .add_html_on_ice_players(
          game = game,
          rosters = pbp_meta$rosterSpots,
          home_team = pbp_meta$homeTeam,
          away_team = pbp_meta$awayTeam
        ) |>
        .add_on_ice_shift_timing_context(
          game = game
        )
      .finalize_pbp_output(plays, source = 'gc')
    },
    error = function(e) {
      message(paste(
        'Invalid argument(s); refer to help file.',
        '\nProvided game:',
        game
      ))
      data.frame()
    }
  )
}

#' @rdname gc_play_by_play
#' @export

gc_pbp <- function(game = 2023030417) {
  gc_play_by_play(game)
}

#' Access the World Showcase (WSC) play-by-play for a game
#'
#' `wsc_play_by_play()` retrieves the World Showcase (WSC) play-by-play for a
#' game as a `data.frame` where each row represents an event. The returned
#' schema follows the same cleaned public-facing naming as `gc_play_by_play()`,
#' and includes `utc` immediately after `secondsElapsedInGame` while omitting
#' GC-only clip fields. It also includes the same HTML-report-derived on-ice
#' player ID columns added to the GC output, including sixth-skater slots when
#' a goalie is pulled, plus the same shift-chart-derived scalar timing columns.
#'
#' @inheritParams gc_summary
#'
#' @returns data.frame with one row per event (play)
#' @examples
#' wsc_pbp_Martin_Necas_legacy_game <- wsc_play_by_play(game = 2025020275)
#' @export

wsc_play_by_play <- function(game = 2023030417) {
  tryCatch(
    expr = {
      game <- as.integer(game)
      pbp_meta <- nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )
      plays        <- nhl_api(
        path = sprintf('v1/wsc/play-by-play/%s', game),
        type = 'w'
      )
      # Rename column.
      plays$id     <- NULL
      plays$gameId <- game
      plays        <- plays[, c('gameId', setdiff(names(plays), 'gameId'))]
      if (
        all(c('typeDescKey', 'shootingPlayerId', 'scoringPlayerId') %in% names(plays))
      ) {
        goal_idx <- plays$typeDescKey == 'goal' &
          is.na(plays$shootingPlayerId) &
          !is.na(plays$scoringPlayerId)
        plays$shootingPlayerId[goal_idx] <- plays$scoringPlayerId[goal_idx]
      }
      # Fix zoneCode for blocked shots.
      idx <- plays$typeDescKey == 'blocked-shot' &
        plays$zoneCode %in% c('O', 'D')
      plays$zoneCode[idx] <- ifelse(
        plays$zoneCode[idx] == 'O',
        'D',
        'O'
      )
      # Remove inconsistent columns.
      plays$goalModifier     <- NULL
      plays$strength         <- NULL
      plays$strengthCode     <- NULL
      plays$goalCode         <- NULL
      plays$secondsRemaining <- NULL
      # Clean.
      plays <- .strip_game_id(plays) |>
        .strip_time_period() |>
        .drop_illogical_ordered_events() |>
        .flag_is_home() |>
        .strip_situation_code() |>
        .normalize_coordinates() |>
        .calculate_distance() |>
        .calculate_angle() |>
        .apply_shot_context() |>
        .add_html_on_ice_players(
          game = game,
          rosters = pbp_meta$rosterSpots,
          home_team = pbp_meta$homeTeam,
          away_team = pbp_meta$awayTeam
        ) |>
        .add_on_ice_shift_timing_context(
          game = game
        )
      .finalize_pbp_output(plays, source = 'wsc')
    },
    error = function(e) {
      message(paste(
        'Invalid argument(s); refer to help file.',
        '\nProvided game:',
        game
      ))
      data.frame()
    }
  )
}

#' @rdname wsc_play_by_play
#' @export

wsc_pbp <- function(game = 2023030417) {
  wsc_play_by_play(game)
}

#' Access the shift chart for a game
#'
#' `shift_chart()` retrieves the shift chart for a game as a `data.frame` where each row represents shift and includes detail on game timeline state, period/clock progression, and matchup flow, date/season filtering windows and chronological context, and team identity, affiliation, and matchup-side context.
#'
#' @inheritParams gc_summary
#'
#' @returns data.frame with one row per shift
#' @examples
#' shifts_Martin_Necas_legacy_game <- shift_chart(game = 2025020275)
#' @export

shift_chart <- function(game = 2023030417) {
  game <- as.integer(game)
  if (length(game) != 1L || is.na(game) || game <= 0L) {
    message(paste(
      'Invalid argument(s); refer to help file.',
      '\nProvided game:',
      paste(game, collapse = ', ')
    ))
    return(data.frame())
  }

  fetch_from_api <- function(game) {
    shifts <- nhl_api(
      path  = 'en/shiftcharts',
      query = list(cayenneExp = sprintf('gameId = %s', game)),
      type  = 's'
    )$data
    shifts <- shifts[order(shifts$teamId), ]
    shifts <- shifts[is.na(shifts$eventDescription), ]
    shifts <- shifts[, c('id', 'gameId', 'teamId', 'playerId', 'shiftNumber', 'period', 'startTime', 'endTime')]
    is_playoffs <- game %/% 1e4 %% 1e2 == 3
    base <- integer(nrow(shifts))
    reg_idx <- shifts$period <= 3L
    ot_idx <- !reg_idx
    base[reg_idx] <- (shifts$period[reg_idx] - 1L) * 1200L
    if (is_playoffs) {
      base[ot_idx] <- 3600L + (shifts$period[ot_idx] - 4L) * 1200L
    } else {
      base[ot_idx] <- 3600L + (shifts$period[ot_idx] - 4L) * 300L
    }
    tp_s  <- strsplit(shifts$startTime, ':', fixed = TRUE)
    s_min <- as.integer(vapply(tp_s, `[`, '', 1L))
    s_sec <- as.integer(vapply(tp_s, `[`, '', 2L))
    s_elp <- 60L * s_min + s_sec
    tp_e  <- strsplit(shifts$endTime, ':', fixed = TRUE)
    e_min <- as.integer(vapply(tp_e, `[`, '', 1L))
    e_sec <- as.integer(vapply(tp_e, `[`, '', 2L))
    e_elp <- 60L * e_min + e_sec
    shifts$startSecondsElapsedInPeriod <- s_elp
    shifts$endSecondsElapsedInPeriod   <- e_elp
    shifts$startSecondsElapsedInGame   <- base + s_elp
    shifts$endSecondsElapsedInGame     <- base + e_elp
    shifts$duration                    <- shifts$endSecondsElapsedInGame - shifts$startSecondsElapsedInGame
    shifts$id <- NULL
    shifts
  }

  fetch_from_html <- function(game) {
    season    <- paste0(game %/% 1e6, game %/% 1e6 + 1)
    game_code <- sprintf('%06d', game %% 10^6)
    normalize_person <- function(x) {
      x <- gsub('\\s+', ' ', x)
      x <- trimws(x)
      x <- toupper(x)
      x <- iconv(x, from = '', to = 'ASCII//TRANSLIT')
      x[is.na(x)] <- ''
      x
    }
    extract_clock <- function(x) {
      if (is.na(x)) return(NA_character_)
      match <- regexpr('[0-9]{1,2}:[0-9]{2}', x)
      if (match[1] < 0L) return(NA_character_)
      substr(
        x,
        match[1],
        match[1] + attr(match, 'match.length')[1] - 1L
      )
    }
    format_clock <- function(x) {
      if (is.na(x)) return(NA_character_)
      parts <- strsplit(x, ':', fixed = TRUE)[[1]]
      if (length(parts) != 2L) return(NA_character_)
      mins <- suppressWarnings(as.integer(parts[1]))
      secs <- suppressWarnings(as.integer(parts[2]))
      if (is.na(mins) || is.na(secs)) return(NA_character_)
      sprintf('%02d:%02d', mins, secs)
    }
    clocks_to_seconds <- function(x) {
      vapply(
        x,
        function(clock) {
          if (
            is.na(clock) ||
            !grepl('^[0-9]{1,2}:[0-9]{2}$', clock)
          ) {
            return(NA_integer_)
          }
          parts <- strsplit(clock, ':', fixed = TRUE)[[1]]
          as.integer(parts[1]) * 60L + as.integer(parts[2])
        },
        integer(1)
      )
    }
    pbp_meta <- nhl_api(
      path = sprintf('v1/gamecenter/%s/play-by-play', game),
      type = 'w'
    )
    rosters <- pbp_meta$rosterSpots
    rosters$sweaterNumber <- suppressWarnings(
      as.integer(rosters$sweaterNumber)
    )
    rosters$playerLabel <- normalize_person(
      paste(rosters$lastName.default, rosters$firstName.default, sep = ', ')
    )
    lookup_player_id <- function(team_id, sweater_number, player_name) {
      idx <- which(rosters$teamId == team_id)
      if (!length(idx)) return(NA_integer_)
      if (!is.na(sweater_number)) {
        idx_num <- idx[rosters$sweaterNumber[idx] == sweater_number]
        if (length(idx_num) == 1L) {
          return(as.integer(rosters$playerId[idx_num]))
        }
        if (length(idx_num) > 1L && nzchar(player_name)) {
          target   <- normalize_person(player_name)
          idx_name <- idx_num[rosters$playerLabel[idx_num] == target]
          if (length(idx_name)) {
            return(as.integer(rosters$playerId[idx_name[1L]]))
          }
        }
        if (length(idx_num)) {
          return(as.integer(rosters$playerId[idx_num[1L]]))
        }
      }
      if (!is.na(player_name) && nzchar(player_name)) {
        target   <- normalize_person(player_name)
        idx_name <- idx[rosters$playerLabel[idx] == target]
        if (length(idx_name)) {
          return(as.integer(rosters$playerId[idx_name[1L]]))
        }
      }
      NA_integer_
    }
    parse_period_label <- function(x) {
      x <- trimws(toupper(x))
      if (grepl('^[0-9]+$', x)) return(as.integer(x))
      if (x == 'OT') return(4L)
      if (grepl('^[0-9]+OT$', x)) {
        return(3L + as.integer(sub('OT$', '', x)))
      }
      NA_integer_
    }
    parse_shift_report <- function(team_tag, team_id) {
      report <- xml2::read_html(sprintf(
        'https://www.nhl.com/scores/htmlreports/%s/%s%s.HTM',
        season,
        team_tag,
        game_code
      ))
      rows <- xml2::xml_find_all(report, './/tr')
      out  <- vector('list', length(rows))
      n_out <- 0L
      current_player_id <- NA_integer_
      current_player_nm <- NA_character_
      for (row in rows) {
        cells <- xml2::xml_find_all(row, './th|./td')
        if (!length(cells)) next
        txt <- xml2::xml_text(cells, trim = TRUE)
        txt <- gsub('\u00A0', ' ', txt, fixed = TRUE)
        txt <- trimws(txt)
        if (
          length(txt) == 1L &&
          grepl('^[0-9]+\\s+.+', txt[1]) &&
          !grepl('^Shift\\s*#', txt[1], ignore.case = TRUE)
        ) {
          m <- regexec('^([0-9]+)\\s+(.+)$', txt[1])
          p <- regmatches(txt[1], m)[[1]]
          if (length(p) >= 3L) {
            sweater_number    <- suppressWarnings(as.integer(p[2]))
            current_player_nm <- p[3]
            current_player_id <- lookup_player_id(
              team_id,
              sweater_number,
              current_player_nm
            )
          }
          next
        }
        is_shift_row <- length(cells) == 6L &&
          length(txt) >= 4L &&
          grepl('^[0-9]+$', txt[1]) &&
          !is.na(parse_period_label(txt[2])) &&
          grepl('/', txt[3], fixed = TRUE) &&
          grepl('/', txt[4], fixed = TRUE) &&
          grepl('[0-9]{1,2}:[0-9]{2}', txt[3]) &&
          grepl('[0-9]{1,2}:[0-9]{2}', txt[4])
        if (!is_shift_row) next
        start_time <- format_clock(extract_clock(txt[3]))
        end_time   <- format_clock(extract_clock(txt[4]))
        if (is.na(start_time) || is.na(end_time)) next
        n_out <- n_out + 1L
        out[[n_out]] <- data.frame(
          gameId      = as.integer(game),
          teamId      = as.integer(team_id),
          playerId    = as.integer(current_player_id),
          shiftNumber = as.integer(txt[1]),
          period      = parse_period_label(txt[2]),
          startTime   = start_time,
          endTime     = end_time,
          stringsAsFactors = FALSE
        )
      }
      if (!n_out) return(data.frame())
      do.call(rbind, out[seq_len(n_out)])
    }
    home_team_id <- as.integer(pbp_meta$homeTeam$id)
    away_team_id <- as.integer(pbp_meta$awayTeam$id)
    shifts_home  <- parse_shift_report('TH', home_team_id)
    shifts_away  <- parse_shift_report('TV', away_team_id)
    shifts       <- rbind(shifts_home, shifts_away)
    if (!nrow(shifts)) stop('No shift rows parsed from HTML reports.')
    shifts$startSecondsElapsedInPeriod <- clocks_to_seconds(shifts$startTime)
    shifts$endSecondsElapsedInPeriod   <- clocks_to_seconds(shifts$endTime)
    is_playoffs <- game %/% 1e4 %% 1e2 == 3
    base <- integer(nrow(shifts))
    reg_idx <- shifts$period <= 3L
    ot_idx <- !reg_idx
    base[reg_idx] <- (shifts$period[reg_idx] - 1L) * 1200L
    if (is_playoffs) {
      base[ot_idx] <- 3600L + (shifts$period[ot_idx] - 4L) * 1200L
    } else {
      base[ot_idx] <- 3600L + (shifts$period[ot_idx] - 4L) * 300L
    }
    shifts$startSecondsElapsedInGame <- base + shifts$startSecondsElapsedInPeriod
    shifts$endSecondsElapsedInGame   <- base + shifts$endSecondsElapsedInPeriod
    if (!is_playoffs) {
      ot_idx <- shifts$period >= 4L
      if (any(ot_idx)) {
        # HTML OT rows can arrive 900 seconds early; re-anchor them to the
        # regular-season OT period start implied by the period label.
        expected_base <- 3600L + (shifts$period[ot_idx] - 4L) * 300L
        actual_base <- shifts$startSecondsElapsedInGame[ot_idx] -
          shifts$startSecondsElapsedInPeriod[ot_idx]
        adjust <- expected_base - actual_base
        shifts$startSecondsElapsedInGame[ot_idx] <- shifts$startSecondsElapsedInGame[ot_idx] + adjust
        shifts$endSecondsElapsedInGame[ot_idx]   <- shifts$endSecondsElapsedInGame[ot_idx] + adjust
      }
    }
    shifts$duration <- shifts$endSecondsElapsedInGame - shifts$startSecondsElapsedInGame
    shifts <- shifts[
      !is.na(shifts$startSecondsElapsedInPeriod) &
        !is.na(shifts$endSecondsElapsedInPeriod),
    ]
    if (!is_playoffs) {
      shifts <- shifts[shifts$period <= 5L, ]
    }
    shifts <- shifts[shifts$duration > 0L, ]
    shifts <- shifts[order(shifts$teamId, shifts$playerId, shifts$shiftNumber), ]
    shifts <- shifts[, c(
      'gameId',
      'teamId',
      'playerId',
      'shiftNumber',
      'period',
      'startTime',
      'endTime',
      'startSecondsElapsedInPeriod',
      'endSecondsElapsedInPeriod',
      'startSecondsElapsedInGame',
      'endSecondsElapsedInGame',
      'duration'
    )]
    shifts
  }

  tryCatch(
    expr = {
      shifts <- fetch_from_html(game)
      if (!nrow(shifts)) stop('No shift rows parsed from HTML reports.')
      shifts
    },
    error = function(e) {
      tryCatch(
        expr = {
          fetch_from_api(game)
        },
        error = function(api_error) {
          message(e)
          message(api_error)
          message(paste(
            'Invalid argument(s); refer to help file.',
            '\nProvided game:',
            game
          ))
          data.frame()
        }
      )
    }
  )
}

#' Access the real-time game odds for a country by partnered bookmaker
#'
#' `game_odds()` retrieves the real-time game odds for a country by partnered bookmaker as a `data.frame` where each row represents game and includes detail on betting market lines, prices, and provider-level context.
#'
#' @param country two-letter code (e.g., 'CA'); see [countries()] for reference
#'
#' @returns data.frame with one row per game
#' @examples
#' game_odds_CA <- game_odds(country = 'CA')
#' @export

game_odds <- function(country = 'US') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf('v1/partner-game/%s/now', country),
        type = 'w'
      )$games
      games[[1]]
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      names(games) <- normalize_locale_names(names(games))
      names(games) <- normalize_team_abbrev_cols(names(games))
      games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
