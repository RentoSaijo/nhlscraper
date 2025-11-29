#' Strip the game ID into the season ID, game type ID, and game number for all 
#' the events (plays) in a play-by-play
#' 
#' `strip_game_id()` strips the game ID into the season ID, game type ID, and 
#' game number for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions
#' @returns data.frame with one row per event (play) and added columns:
#' `seasonId`, `gameTypeId`, and `gameNumber`
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                  <- gc_play_by_play()
#'   test_game_id_stripped <- strip_game_id(test)
#' }
#' @export

strip_game_id <- function(play_by_play) {
  tryCatch(
    expr = {
      gid_chr      <- as.character(play_by_play[['gameId']])
      season_start <- as.integer(substr(gid_chr, 1, 4))
      game_type    <- as.integer(substr(gid_chr, 5, 6))
      game_number  <- as.integer(substr(gid_chr, 7, 10))
      season_id <- ifelse(
        is.na(season_start),
        NA_integer_,
        season_start * 1e5 + (season_start + 1L)
      )
      play_by_play[['seasonId']]   <- season_id
      play_by_play[['gameTypeId']] <- game_type
      play_by_play[['gameNumber']] <- game_number
      new_cols   <- c('seasonId', 'gameTypeId', 'gameNumber')
      other_cols <- setdiff(names(play_by_play), new_cols)
      play_by_play[c(new_cols, other_cols)]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Strip the timestamp and period number into the time elapsed in the period 
#' and game for all the events (plays) in a play-by-play
#' 
#' `strip_time_period()` strip the timestamp and period number into the time 
#' elapsed in the period and game for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [strip_game_id()] has already been 
#' called
#' @returns data.frame with one row per event (play) and added columns
#' `secondsElapsedInPeriod` and `secondsElapsedInGame`
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                      <- gc_play_by_play()
#'   test_game_id_stripped     <- strip_game_id(test)
#'   test_time_period_stripped <- strip_time_period(test_game_id_stripped)
#' }
#' @export

strip_time_period <- function(play_by_play) {
  tryCatch(
    expr = {
      had_season_id   <- 'seasonId'   %in% names(play_by_play)
      had_game_type   <- 'gameTypeId' %in% names(play_by_play)
      had_game_number <- 'gameNumber' %in% names(play_by_play)
      if (!had_game_type) {
        play_by_play <- strip_game_id(play_by_play)
      }
      tip <- as.character(play_by_play[['timeInPeriod']])
      mm  <- suppressWarnings(as.integer(sub(':.*', '', tip)))
      ss  <- suppressWarnings(as.integer(sub('.*:', '', tip)))
      seconds_in_period <- mm * 60L + ss
      gtype <- suppressWarnings(as.integer(play_by_play[['gameTypeId']]))
      per   <- suppressWarnings(as.integer(play_by_play[['period']]))
      n      <- length(seconds_in_period)
      offset <- rep(NA_integer_, n)
      idx_po <- !is.na(gtype) & gtype == 3L & !is.na(per)
      if (any(idx_po)) {
        offset[idx_po] <- (pmax(per[idx_po], 1L) - 1L) * 1200L
      }
      idx_rs <- !is.na(gtype) & gtype %in% c(1L, 2L) & !is.na(per)
      if (any(idx_rs)) {
        p      <- per[idx_rs]
        off_rs <- rep(NA_integer_, length(p))
        idx_123         <- p <= 3L
        off_rs[idx_123] <- (p[idx_123] - 1L) * 1200L
        idx_4 <- p == 4L
        if (any(idx_4)) {
          off_rs[idx_4] <- 3L * 1200L
        }
        idx_5p <- p >= 5L
        if (any(idx_5p)) {
          off_rs[idx_5p] <- 3L * 1200L + 300L
        }
        offset[idx_rs] <- off_rs
      }
      idx_other <- !is.na(gtype) & !(gtype %in% c(1L, 2L, 3L)) & !is.na(per)
      if (any(idx_other)) {
        offset[idx_other] <- (pmax(per[idx_other], 1L) - 1L) * 1200L
      }
      seconds_in_game <- offset + seconds_in_period
      play_by_play[['secondsElapsedInPeriod']] <- seconds_in_period
      play_by_play[['secondsElapsedInGame']]   <- seconds_in_game
      if (!had_season_id   && 'seasonId'   %in% names(play_by_play)) {
        play_by_play[['seasonId']] <- NULL
      }
      if (!had_game_number && 'gameNumber' %in% names(play_by_play)) {
        play_by_play[['gameNumber']] <- NULL
      }
      if (!had_game_type   && 'gameTypeId' %in% names(play_by_play)) {
        play_by_play[['gameTypeId']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Strip the situation code into goalie and skater counts, man differential, 
#' and strength state for all the events (plays) in a play-by-play by 
#' perspective
#' 
#' `strip_situation_code()` strip the situation code into goalie and skater 
#' counts, man differential, and strength state for all the events (plays) in a 
#' play-by-play by perspective.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [flag_is_home()] has already been 
#' called
#' @returns data.frame with one row per event (play) and added columns:
#' `homeIsEmptyNet`, `awayIsEmptyNet`, `homeSkaterCount`, `awaySkaterCount`,
#' `isEmptyNetFor`, `isEmptyNetAgainst`, `skaterCountFor`, 
#' `skaterCountAgainst`, `manDifferential`, and `strengthState`
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                         <- gc_play_by_play()
#'   test_is_home_flagged         <- flag_is_home(test)
#'   test_situation_code_stripped <- strip_situation_code(test_is_home_flagged)
#' }
#' @export

strip_situation_code <- function(play_by_play) {
  tryCatch(
    expr = {
      had_is_home <- 'isHome' %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      raw_situation <- play_by_play[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation     <- rep(NA_character_, length(situation_chr))
      valid         <- !is.na(situation_chr) & nchar(situation_chr) > 0L
      if (any(valid)) {
        situation[valid] <- sprintf('%04d', as.integer(situation_chr[valid]))
      }
      away_goalie_in <- as.integer(substr(situation, 1L, 1L))
      away_skaters   <- as.integer(substr(situation, 2L, 2L))
      home_skaters   <- as.integer(substr(situation, 3L, 3L))
      home_goalie_in <- as.integer(substr(situation, 4L, 4L))
      away_empty <- ifelse(is.na(away_goalie_in), NA, away_goalie_in == 0L)
      home_empty <- ifelse(is.na(home_goalie_in), NA, home_goalie_in == 0L)
      play_by_play[['homeIsEmptyNet']] <- home_empty
      play_by_play[['awayIsEmptyNet']] <- away_empty
      play_by_play[['homeSkaterCount']] <- home_skaters
      play_by_play[['awaySkaterCount']] <- away_skaters
      is_home <- play_by_play[['isHome']]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      n <- length(is_home)
      goalie_for     <- rep(NA_integer_, n)
      goalie_against <- rep(NA_integer_, n)
      skater_for     <- rep(NA_integer_, n)
      skater_against <- rep(NA_integer_, n)
      home_idx <- !is.na(is_home) & is_home
      if (any(home_idx)) {
        goalie_for[home_idx]     <- home_goalie_in[home_idx]
        goalie_against[home_idx] <- away_goalie_in[home_idx]
        skater_for[home_idx]     <- home_skaters[home_idx]
        skater_against[home_idx] <- away_skaters[home_idx]
      }
      away_idx <- !is.na(is_home) & !is_home
      if (any(away_idx)) {
        goalie_for[away_idx]     <- away_goalie_in[away_idx]
        goalie_against[away_idx] <- home_goalie_in[away_idx]
        skater_for[away_idx]     <- away_skaters[away_idx]
        skater_against[away_idx] <- home_skaters[away_idx]
      }
      is_empty_for     <- ifelse(is.na(goalie_for), NA, goalie_for == 0L)
      is_empty_against <- ifelse(is.na(goalie_against), NA, goalie_against == 0L)
      play_by_play[['isEmptyNetFor']]     <- is_empty_for
      play_by_play[['isEmptyNetAgainst']] <- is_empty_against
      play_by_play[['skaterCountFor']]    <- skater_for
      play_by_play[['skaterCountAgainst']] <- skater_against
      man_diff <- (goalie_for + skater_for) - (goalie_against + skater_against)
      play_by_play[['manDifferential']] <- man_diff
      strength_state <- rep(NA_character_, n)
      strength_state[!is.na(man_diff) & man_diff == 0L]  <- 'even-strength'
      strength_state[!is.na(man_diff) & man_diff >  0L]  <- 'power-play'
      strength_state[!is.na(man_diff) & man_diff <  0L]  <- 'penalty-kill'
      play_by_play[['strengthState']] <- strength_state
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Flag if the event belongs to the home team or not for all the events (plays) 
#' in a play-by-play
#' 
#' `flag_is_home()` flags if the event belongs to the home team or not for 
#' all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions
#' @returns data.frame with one row per event (play) and added `isHome` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                 <- gc_play_by_play()
#'   test_is_home_flagged <- flag_is_home(test)
#' }
#' @export

flag_is_home <- function(play_by_play) {
  tryCatch(
    expr = {
      games         <- games()
      data_game_id  <- as.character(play_by_play[['gameId']])
      games_game_id <- as.character(games[['id']])
      idx           <- match(data_game_id, games_game_id)
      home_ids  <- games[['homeTeamId']][idx]
      owner_ids <- play_by_play[['eventOwnerTeamId']]
      is_home <- rep(NA, length(owner_ids))
      valid   <- !is.na(owner_ids) & !is.na(home_ids)
      if (any(valid)) {
        is_home[valid] <-
          as.character(owner_ids[valid]) == as.character(home_ids[valid])
      }
      play_by_play[['isHome']] <- is_home
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Flag if the shot attempt is a rebound attempt or not for all the shots in a 
#' play-by-play
#' 
#' `flag_is_rebound()` flags if the shot attempt is a rebound attempt or not 
#' for all the shots in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [flag_is_home()] and/or 
#' @returns data.frame with one row per event (play) and added `isRebound` 
#' column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                      <- gc_play_by_play()
#'   test_is_home_flagged      <- flag_is_home(test)
#'   test_game_id_stripped     <- strip_game_id(test_is_home_flagged)
#'   test_time_period_stripped <- strip_time_period(test_game_id_stripped)
#'   test_is_rebound_flagged   <- flag_is_rebound(test_time_period_stripped)
#' }
#' @export

flag_is_rebound <- function(play_by_play) {
  tryCatch(
    expr = {
      had_is_home      <- 'isHome' %in% names(play_by_play)
      had_sec_elapsed  <- 'secondsElapsedInGame' %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      if (!had_sec_elapsed) {
        play_by_play <- strip_time_period(play_by_play)
      }
      n <- nrow(play_by_play)
      game_id    <- as.character(play_by_play[['gameId']])
      sort_order <- as.numeric(play_by_play[['sortOrder']])
      sec_game   <- as.numeric(play_by_play[['secondsElapsedInGame']])
      is_home <- play_by_play[['isHome']]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      type <- as.character(play_by_play[['typeDescKey']])
      is_attempt <- !is.na(type) & type %in% c(
        'goal',
        'shot-on-goal',
        'missed-shot',
        'blocked-shot'
      )
      is_source <- !is.na(type) & type %in% c(
        'shot-on-goal',
        'missed-shot',
        'blocked-shot'
      )
      is_faceoff <- !is.na(type) & type == 'faceoff'
      is_rebound <- rep(FALSE, n)
      uniq_games <- unique(game_id)
      uniq_games <- uniq_games[!is.na(uniq_games)]
      for (g in uniq_games) {
        idx <- which(game_id == g)
        if (length(idx) == 0L) next
        ord     <- order(sort_order[idx], na.last = TRUE)
        idx_ord <- idx[ord]
        last_home_time <- NA_real_
        last_away_time <- NA_real_
        for (pos in seq_along(idx_ord)) {
          i  <- idx_ord[pos]
          ih <- is_home[i]
          t  <- sec_game[i]
          if (is_faceoff[i]) {
            last_home_time <- NA_real_
            last_away_time <- NA_real_
            next
          }
          if (!is_attempt[i]) {
            next
          }
          if (is.na(ih) || is.na(t)) {
            next
          }
          if (ih) {
            if (!is.na(last_home_time)) {
              dt <- t - last_home_time
              if (dt >= 0 && dt <= 3) {
                is_rebound[i] <- TRUE
              }
            }
          } else {
            if (!is.na(last_away_time)) {
              dt <- t - last_away_time
              if (dt >= 0 && dt <= 3) {
                is_rebound[i] <- TRUE
              }
            }
          }
          if (is_source[i]) {
            if (ih) {
              last_home_time <- t
            } else {
              last_away_time <- t
            }
          }
        }
      }
      play_by_play[['isRebound']] <- is_rebound
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      if (!had_sec_elapsed && 'secondsElapsedInGame' %in% names(play_by_play)) {
        play_by_play[['secondsElapsedInGame']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Flag if the shot attempt is a rush attempt or not for all the shots in a 
#' play-by-play
#' 
#' `flag_is_rush()` flags if the shot attempt is a rush attempt or not for all 
#' the shots in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [flag_is_home()] and 
#' [strip_time_period()] had already been called
#' @returns data.frame with one row per event (play) and added `isRush` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                      <- gc_play_by_play()
#'   test_is_home_flagged      <- flag_is_home(test)
#'   test_game_id_stripped     <- strip_game_id(test_is_home_flagged)
#'   test_time_period_stripped <- strip_time_period(test_game_id_stripped)
#'   test_is_rush_flagged      <- flag_is_rush(test_time_period_stripped)
#' }
#' @export

flag_is_rush <- function(play_by_play) {
  tryCatch(
    expr = {
      had_is_home     <- 'isHome' %in% names(play_by_play)
      had_sec_elapsed <- 'secondsElapsedInGame' %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      if (!had_sec_elapsed) {
        play_by_play <- strip_time_period(play_by_play)
      }
      n <- nrow(play_by_play)
      game_id    <- as.character(play_by_play[['gameId']])
      sort_order <- as.numeric(play_by_play[['sortOrder']])
      sec_game   <- as.numeric(play_by_play[['secondsElapsedInGame']])
      is_home <- play_by_play[['isHome']]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      type       <- as.character(play_by_play[['typeDescKey']])
      zone_owner <- as.character(play_by_play[['zoneCode']])
      is_attempt <- !is.na(type) & type %in% c(
        'goal',
        'shot-on-goal',
        'missed-shot',
        'blocked-shot'
      )
      is_faceoff <- !is.na(type) & type == 'faceoff'
      is_rush <- rep(FALSE, n)
      flip_zone_single <- function(z) {
        if (is.na(z)) return(NA_character_)
        if (z == 'O') return('D')
        if (z == 'D') return('O')
        if (z == 'N') return('N')
        NA_character_
      }
      uniq_games <- unique(game_id)
      uniq_games <- uniq_games[!is.na(uniq_games)]
      for (g in uniq_games) {
        idx <- which(game_id == g)
        if (length(idx) == 0L) next
        ord     <- order(sort_order[idx], na.last = TRUE)
        idx_ord <- idx[ord]
        last_ND_home <- NA_real_
        last_ND_away <- NA_real_
        for (pos in seq_along(idx_ord)) {
          i  <- idx_ord[pos]
          ih <- is_home[i]
          t  <- sec_game[i]
          ty <- type[i]
          if (!is.na(ty) && ty == 'faceoff') {
            last_ND_home <- NA_real_
            last_ND_away <- NA_real_
            next
          }
          if (is_attempt[i] && !is.na(ih) && !is.na(t)) {
            if (ih) {
              if (!is.na(last_ND_home)) {
                dt <- t - last_ND_home
                if (dt >= 0 && dt <= 4) {
                  is_rush[i] <- TRUE
                }
              }
            } else {
              if (!is.na(last_ND_away)) {
                dt <- t - last_ND_away
                if (dt >= 0 && dt <= 4) {
                  is_rush[i] <- TRUE
                }
              }
            }
          }
          z_owner <- zone_owner[i]
          if (!is.na(ih) && !is.na(t) && !is.na(z_owner)) {
            if (ih) {
              z_home <- z_owner
              z_away <- flip_zone_single(z_owner)
            } else {
              z_away <- z_owner
              z_home <- flip_zone_single(z_owner)
            }
            if (!is.na(z_home) && z_home %in% c('D', 'N')) {
              last_ND_home <- t
            }
            if (!is.na(z_away) && z_away %in% c('D', 'N')) {
              last_ND_away <- t
            }
          }
        }
      }
      play_by_play[['isRush']] <- is_rush
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      if (!had_sec_elapsed && 'secondsElapsedInGame' %in% names(play_by_play)) {
        play_by_play[['secondsElapsedInGame']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Count the as-of-event goal, shots on goal, Fenwick, and Corsi attempts and 
#' differentials for all the events (plays) in a play-by-play by perspective
#' 
#' `count_goals_shots()` counts the as-of-event goal, shots on goal, Fenwick, 
#' and Corsi attempts and differentials for all the events (plays) in a 
#' play-by-play by perspective.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [flag_is_home()] has already been 
#' called
#' @returns data.frame with one row per event (play) and added columns:
#' `homeGoals`, `awayGoals`, `homeSOG`, `awaySOG`, `homeFenwick`, 
#' `awayFenwick`, `homeCorsi`, `awayCorsi`, `goalsFor`, `goalsAgainst`, 
#' `SOGFor`, `SOGAgainst`, `fenwickFor`, `fenwickAgainst`, `corsiFor`, 
#' `corsiAgainst`, `goalDifferential`, `SOGDifferential`, 
#' `fenwickDifferential`, and `corsiDifferential`
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                     <- gc_play_by_play()
#'   test_is_home_flagged     <- flag_is_home(test)
#'   test_goals_shots_counted <- count_goals_shots(test_is_home_flagged)
#' }
#' @export

count_goals_shots <- function(play_by_play) {
  tryCatch(
    expr = {
      had_is_home <- 'isHome' %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      n <- nrow(play_by_play)
      game_id    <- as.character(play_by_play[['gameId']])
      sort_order <- as.numeric(play_by_play[['sortOrder']])
      is_home <- play_by_play[['isHome']]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      type <- as.character(play_by_play[['typeDescKey']])
      is_goal  <- !is.na(type) & type == 'goal'
      is_sog   <- is_goal | (!is.na(type) & type == 'shot-on-goal')
      is_fen   <- is_sog  | (!is.na(type) & type == 'missed-shot')
      is_corsi <- is_fen  | (!is.na(type) & type == 'blocked-shot')
      goals_for         <- rep(NA_integer_, n)
      goals_against     <- rep(NA_integer_, n)
      sog_for           <- rep(NA_integer_, n)
      sog_against       <- rep(NA_integer_, n)
      fen_for           <- rep(NA_integer_, n)
      fen_against       <- rep(NA_integer_, n)
      corsi_for         <- rep(NA_integer_, n)
      corsi_against     <- rep(NA_integer_, n)
      home_goals_vec    <- rep(NA_integer_, n)
      away_goals_vec    <- rep(NA_integer_, n)
      home_sog_vec      <- rep(NA_integer_, n)
      away_sog_vec      <- rep(NA_integer_, n)
      home_fen_vec      <- rep(NA_integer_, n)
      away_fen_vec      <- rep(NA_integer_, n)
      home_corsi_vec    <- rep(NA_integer_, n)
      away_corsi_vec    <- rep(NA_integer_, n)
      uniq_games <- unique(game_id)
      uniq_games <- uniq_games[!is.na(uniq_games)]
      for (g in uniq_games) {
        idx <- which(game_id == g)
        if (length(idx) == 0L) next
        ord     <- order(sort_order[idx], na.last = TRUE)
        idx_ord <- idx[ord]
        home_goals <- 0L
        away_goals <- 0L
        home_sog   <- 0L
        away_sog   <- 0L
        home_fen   <- 0L
        away_fen   <- 0L
        home_corsi <- 0L
        away_corsi <- 0L
        last_goals_for         <- NA_integer_
        last_goals_against     <- NA_integer_
        last_sog_for           <- NA_integer_
        last_sog_against       <- NA_integer_
        last_fen_for           <- NA_integer_
        last_fen_against       <- NA_integer_
        last_corsi_for         <- NA_integer_
        last_corsi_against     <- NA_integer_
        for (pos in seq_along(idx_ord)) {
          i  <- idx_ord[pos]
          ih <- is_home[i]
          home_goals_vec[i] <- home_goals
          away_goals_vec[i] <- away_goals
          home_sog_vec[i]   <- home_sog
          away_sog_vec[i]   <- away_sog
          home_fen_vec[i]   <- home_fen
          away_fen_vec[i]   <- away_fen
          home_corsi_vec[i] <- home_corsi
          away_corsi_vec[i] <- away_corsi
          if (!is.na(ih)) {
            if (ih) {
              gf <- home_goals
              ga <- away_goals
              sf <- home_sog
              sa <- away_sog
              ff <- home_fen
              fa <- away_fen
              cf <- home_corsi
              ca <- away_corsi
            } else {
              gf <- away_goals
              ga <- home_goals
              sf <- away_sog
              sa <- home_sog
              ff <- away_fen
              fa <- home_fen
              cf <- away_corsi
              ca <- home_corsi
            }
            goals_for[i]     <- gf
            goals_against[i] <- ga
            sog_for[i]       <- sf
            sog_against[i]   <- sa
            fen_for[i]       <- ff
            fen_against[i]   <- fa
            corsi_for[i]     <- cf
            corsi_against[i] <- ca
            if (ih) {
              if (is_goal[i])  home_goals <- home_goals + 1L
              if (is_sog[i])   home_sog   <- home_sog   + 1L
              if (is_fen[i])   home_fen   <- home_fen   + 1L
              if (is_corsi[i]) home_corsi <- home_corsi + 1L
            } else {
              if (is_goal[i])  away_goals <- away_goals + 1L
              if (is_sog[i])   away_sog   <- away_sog   + 1L
              if (is_fen[i])   away_fen   <- away_fen   + 1L
              if (is_corsi[i]) away_corsi <- away_corsi + 1L
            }
            if (ih) {
              last_goals_for         <- home_goals
              last_goals_against     <- away_goals
              last_sog_for           <- home_sog
              last_sog_against       <- away_sog
              last_fen_for           <- home_fen
              last_fen_against       <- away_fen
              last_corsi_for         <- home_corsi
              last_corsi_against     <- away_corsi
            } else {
              last_goals_for         <- away_goals
              last_goals_against     <- home_goals
              last_sog_for           <- away_sog
              last_sog_against       <- home_sog
              last_fen_for           <- away_fen
              last_fen_against       <- home_fen
              last_corsi_for         <- away_corsi
              last_corsi_against     <- home_corsi
            }
          } else {
            if (!is.na(last_goals_for)) {
              goals_for[i]     <- last_goals_for
              goals_against[i] <- last_goals_against
              sog_for[i]       <- last_sog_for
              sog_against[i]   <- last_sog_against
              fen_for[i]       <- last_fen_for
              fen_against[i]   <- last_fen_against
              corsi_for[i]     <- last_corsi_for
              corsi_against[i] <- last_corsi_against
            } else {
              goals_for[i]     <- home_goals
              goals_against[i] <- away_goals
              sog_for[i]       <- home_sog
              sog_against[i]   <- away_sog
              fen_for[i]       <- home_fen
              fen_against[i]   <- away_fen
              corsi_for[i]     <- home_corsi
              corsi_against[i] <- away_corsi
            }
          }
        }
      }
      play_by_play[['homeGoals']]    <- home_goals_vec
      play_by_play[['awayGoals']]    <- away_goals_vec
      play_by_play[['homeSOG']]      <- home_sog_vec
      play_by_play[['awaySOG']]      <- away_sog_vec
      play_by_play[['homeFenwick']]  <- home_fen_vec
      play_by_play[['awayFenwick']]  <- away_fen_vec
      play_by_play[['homeCorsi']]    <- home_corsi_vec
      play_by_play[['awayCorsi']]    <- away_corsi_vec
      play_by_play[['goalsFor']]     <- goals_for
      play_by_play[['goalsAgainst']] <- goals_against
      play_by_play[['SOGFor']]       <- sog_for
      play_by_play[['SOGAgainst']]   <- sog_against
      play_by_play[['fenwickFor']]   <- fen_for
      play_by_play[['fenwickAgainst']] <- fen_against
      play_by_play[['corsiFor']]     <- corsi_for
      play_by_play[['corsiAgainst']] <- corsi_against
      play_by_play[['goalDifferential']]    <- goals_for - goals_against
      play_by_play[['SOGDifferential']]     <- sog_for   - sog_against
      play_by_play[['fenwickDifferential']] <- fen_for   - fen_against
      play_by_play[['corsiDifferential']]   <- corsi_for - corsi_against
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Normalize the x and y coordinates for all the events (plays) in a 
#' play-by-play
#' 
#' `normalize_coordinates()` normalizes the x and y coordinates for all the 
#' events (plays) in a play-by-play such that they all attack towards +x.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [flag_is_home()] has already been 
#' called
#' @returns data.frame with one row per event (play) and added columns 
#' `xCoordNorm` and `yCoordNorm`
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                   <- gc_play_by_play()
#'   test_is_home_flagged   <- flag_is_home(test)
#'   test_coords_normalized <- normalize_coordinates(test_is_home_flagged)
#' }
#' @export

normalize_coordinates <- function(play_by_play) {
  tryCatch(
    expr = {
      had_is_home <- 'isHome' %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      is_home <- play_by_play[['isHome']]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      home_def <- tolower(as.character(play_by_play[['homeTeamDefendingSide']]))
      x        <- as.numeric(play_by_play[['xCoord']])
      y        <- as.numeric(play_by_play[['yCoord']])
      n    <- length(x)
      mult <- rep(NA_integer_, n)
      valid <- !is.na(is_home) & !is.na(home_def)
      left_idx <- valid & home_def == 'left'
      if (any(left_idx)) {
        mult[left_idx] <- ifelse(is_home[left_idx],  1L, -1L)
      }
      right_idx <- valid & home_def == 'right'
      if (any(right_idx)) {
        mult[right_idx] <- ifelse(is_home[right_idx], -1L,  1L)
      }
      play_by_play[['xCoordNorm']] <- x * mult
      play_by_play[['yCoordNorm']] <- y * mult
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Calculate the Euclidean distance from the attacking net for all the events 
#' (plays) in a play-by-play
#' 
#' `calculate_distance()` calculates the Euclidean distance from the attacking 
#' net for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [normalize_coordinates()] has 
#' already been called
#' @returns data.frame with one row per event (play) and added `distance` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                     <- gc_play_by_play()
#'   test_is_home_flagged     <- flag_is_home(test)
#'   test_coords_normalized   <- normalize_coordinates(test_is_home_flagged)
#'   test_distance_calculated <- calculate_distance(test_coords_normalized)
#' }
#' @export

calculate_distance <- function(play_by_play) {
  tryCatch(
    expr = {
      had_x_norm <- 'xCoordNorm' %in% names(play_by_play)
      had_y_norm <- 'yCoordNorm' %in% names(play_by_play)
      if (!had_x_norm || !had_y_norm) {
        play_by_play <- normalize_coordinates(play_by_play)
      }
      x  <- as.numeric(play_by_play[['xCoordNorm']])
      y  <- as.numeric(play_by_play[['yCoordNorm']])
      dx <- 89 - x
      dy <- 0 - y
      distance <- sqrt(dx^2 + dy^2)
      play_by_play[['distance']] <- distance
      if (!had_x_norm && 'xCoordNorm' %in% names(play_by_play)) {
        play_by_play[['xCoordNorm']] <- NULL
      }
      if (!had_y_norm && 'yCoordNorm' %in% names(play_by_play)) {
        play_by_play[['yCoordNorm']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' Calculate the Euclidean angle from the attacking net for all the events 
#' (plays) in a play-by-play
#' 
#' `calculate_angle()` calculates the Euclidean angle from the attacking net 
#' for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [normalize_coordinates()] has 
#' already been called
#' @returns data.frame with one row per event (play) and added `angle` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                   <- gc_play_by_play()
#'   test_is_home_flagged   <- flag_is_home(test)
#'   test_coords_normalized <- normalize_coordinates(test_is_home_flagged)
#'   test_angle_calculated  <- calculate_angle(test_coords_normalized)
#' }
#' @export

calculate_angle <- function(play_by_play) {
  tryCatch(
    expr = {
      had_x_norm <- 'xCoordNorm' %in% names(play_by_play)
      had_y_norm <- 'yCoordNorm' %in% names(play_by_play)
      if (!had_x_norm || !had_y_norm) {
        play_by_play <- normalize_coordinates(play_by_play)
      }
      x  <- as.numeric(play_by_play[['xCoordNorm']])
      y  <- as.numeric(play_by_play[['yCoordNorm']])
      dx <- 89 - x
      dy <- 0 - y
      angle <- atan2(abs(dy), dx) * 180 / pi
      play_by_play[['angle']] <- angle
      if (!had_x_norm && 'xCoordNorm' %in% names(play_by_play)) {
        play_by_play[['xCoordNorm']] <- NULL
      }
      if (!had_y_norm && 'yCoordNorm' %in% names(play_by_play)) {
        play_by_play[['yCoordNorm']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}
