#' Strip the game ID into the season ID, game type ID, and game number for all 
#' the events (plays) in a play-by-play
#' 
#' `strip_game_id()` strips the game ID into the season ID, game type ID, and 
#' game number for all the events (plays) in a play-by-play.
#' 
#' @param data data.frame of play-by-play(s); see [gc_play_by_play()] and/or 
#' [wsc_play_by_play()] for reference
#' @param game_id_name name of column that contains game ID
#' @param season_id_name name of column that you want contain season ID
#' @param game_type_id_name name of column that you want contain game type ID
#' @param game_number_name name of column that you want contain game number
#' @returns data.frame with one row per event (play)
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                 <- gc_play_by_play()
#'   test_gameId_stripped <- strip_game_id(test)
#' }
#' @export

strip_game_id <- function(
  data,
  game_id_name      = 'gameId',
  season_id_name    = 'seasonId',
  game_type_id_name = 'gameTypeId',
  game_number_name  = 'gameNumber'
) {
  tryCatch(
    expr = {
      gid_chr      <- as.character(data[[game_id_name]])
      season_start <- as.integer(substr(gid_chr, 1, 4))
      game_type    <- as.integer(substr(gid_chr, 5, 6))
      game_number  <- as.integer(substr(gid_chr, 7, 10))
      season_id <- ifelse(
        is.na(season_start),
        NA_integer_,
        season_start * 1e5 + (season_start + 1)
      )
      data[[season_id_name]]    <- season_id
      data[[game_type_id_name]] <- game_type
      data[[game_number_name]]  <- game_number
      new_cols   <- c(season_id_name, game_type_id_name, game_number_name)
      other_cols <- setdiff(names(data), new_cols)
      data[c(new_cols, other_cols)]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

#' Strip the timestamp and period number into the time elapsed in the period 
#' and game for all the events (plays) in a play-by-play
#' 
#' `strip_time_period()` strip the timestamp and period number into the time 
#' elapsed in the period and game for all the events (plays) in a play-by-play.
#' 
#' @inheritParams strip_game_id
#' @param game_type_id_name name of column that contains game type ID; see 
#' [strip_game_id()] for reference
#' @param time_in_period_name name of column that contains time in period in 
#' 'MM:SS'
#' @param period_number_name name of column that contains period number
#' @param seconds_elapsed_in_period_name name of column that you want contain 
#' seconds elapsed in period
#' @param seconds_elapsed_in_game_name name of column that you want contain 
#' seconds elapsed in game
#' @returns data.frame with one row per event (play)
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                      <- gc_play_by_play()
#'   test_game_id_stripped     <- strip_game_id(test)
#'   test_time_period_stripped <- strip_time_period(test_game_id_stripped)
#' }
#' @export

strip_time_period <- function(
    data,
    game_type_id_name              = 'gameTypeId',
    time_in_period_name            = 'timeInPeriod',
    period_number_name             = 'periodNumber',
    seconds_elapsed_in_period_name = 'secondsElapsedInPeriod',
    seconds_elapsed_in_game_name   = 'secondsElapsedInGame'
) {
  tryCatch(
    expr = {
      tip <- as.character(data[[time_in_period_name]])
      mm  <- suppressWarnings(as.integer(sub(':.*', '', tip)))
      ss  <- suppressWarnings(as.integer(sub('.*:', '', tip)))
      seconds_in_period <- mm * 60 + ss
      gtype  <- suppressWarnings(as.integer(data[[game_type_id_name]]))
      per    <- suppressWarnings(as.integer(data[[period_number_name]]))
      n      <- length(seconds_in_period)
      offset <- rep(NA_integer_, n)
      idx_po <- !is.na(gtype) & gtype == 3 & !is.na(per)
      if (any(idx_po)) {
        offset[idx_po] <- (pmax(per[idx_po], 1) - 1) * 1200
      }
      idx_rs <- !is.na(gtype) & gtype %in% c(1, 2) & !is.na(per)
      if (any(idx_rs)) {
        p                <- per[idx_rs]
        off_rs           <- rep(NA_integer_, length(p))
        idx_123          <- p <= 3
        off_rs[idx_123]  <- (p[idx_123] - 1) * 1200
        idx_4 <- p == 4
        if (any(idx_4)) {
          off_rs[idx_4]  <- 3 * 1200
        }
        idx_5p <- p >= 5
        if (any(idx_5p)) {
          off_rs[idx_5p] <- 3 * 1200 + 300
        }
        offset[idx_rs]   <- off_rs
      }
      idx_other <- !is.na(gtype) & !(gtype %in% c(1, 2, 3)) & !is.na(per)
      if (any(idx_other)) {
        offset[idx_other] <- (pmax(per[idx_other], 1) - 1) * 1200
      }
      seconds_in_game <- offset + seconds_in_period
      data[[seconds_elapsed_in_period_name]] <- seconds_in_period
      data[[seconds_elapsed_in_game_name]]   <- seconds_in_game
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

#' Strip the situation code into goalie and skater counts for all the events 
#' (plays) in a play-by-play by perspective
#' 
#' `strip_situation_code()` strip the situation code into goalie and skater 
#' counts for all the events (plays) in a play-by-play by perspective.
#' 
#' @inheritParams strip_game_id
#' @param is_home_name name of column that contains home/away logical 
#' indicator; see [flag_is_home()] for reference
#' @param situation_code_name name of column that contains situation code
#' @param home_is_empty_net_name name of column that you want contain empty net 
#' indicator for home team
#' @param away_is_empty_net_name name of column that you want contain empty net 
#' indicator for away team
#' @param home_skater_count_name name of column that you want contain skater 
#' count for home team
#' @param away_skater_count_name name of column that you want contain skater 
#' count for away team
#' @param is_empty_net_for_name name of column that you want contain empty net 
#' indicator for event-owning team
#' @param is_empty_net_against_name name of column that you want contain empty 
#' net indicator for opposing team
#' @param skater_count_for_name name of column that you want contain skater 
#' count for event-owning team
#' @param skater_count_against_name name of column that you want contain skater 
#' count for opposing team
#' @param man_differential_name name of column that you want contain man 
#' differential
#' @param strength_state_name name of column that you want contain strength 
#' state
#' @returns data.frame with one row per event (play)
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test                         <- gc_play_by_play()
#'   test_is_home_flagged         <- flag_is_home(test)
#'   test_situation_code_stripped <- strip_situation_code(test_is_home_flagged)
#' }
#' @export

strip_situation_code <- function(
  data,
  is_home_name              = 'isHome',
  situation_code_name       = 'situationCode',
  home_is_empty_net_name    = 'homeIsEmptyNet',
  away_is_empty_net_name    = 'awayIsEmptyNet',
  home_skater_count_name    = 'homeSkaterCount',
  away_skater_count_name    = 'awaySkaterCount',
  is_empty_net_for_name     = 'isEmptyNetFor',
  is_empty_net_against_name = 'isEmptyNetAgainst',
  skater_count_for_name     = 'skaterCountFor',
  skater_count_against_name = 'skaterCountAgainst',
  man_differential_name     = 'manDifferential',
  strength_state_name       = 'strengthState'
) {
  tryCatch(
    expr = {
      situation <- as.character(data[[situation_code_name]])
      away_goalie_in <- as.integer(substr(situation, 1, 1))
      away_skaters   <- as.integer(substr(situation, 2, 2))
      home_skaters   <- as.integer(substr(situation, 3, 3))
      home_goalie_in <- as.integer(substr(situation, 4, 4))
      away_empty <- ifelse(is.na(away_goalie_in), NA, away_goalie_in == 0)
      home_empty <- ifelse(is.na(home_goalie_in), NA, home_goalie_in == 0)
      data[[home_is_empty_net_name]] <- home_empty
      data[[away_is_empty_net_name]] <- away_empty
      data[[home_skater_count_name]] <- home_skaters
      data[[away_skater_count_name]] <- away_skaters
      is_home <- data[[is_home_name]]
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
      is_empty_for     <- ifelse(is.na(goalie_for), NA, goalie_for == 0)
      is_empty_against <- ifelse(is.na(goalie_against), NA, goalie_against == 0)
      data[[is_empty_net_for_name]]     <- is_empty_for
      data[[is_empty_net_against_name]] <- is_empty_against
      data[[skater_count_for_name]]     <- skater_for
      data[[skater_count_against_name]] <- skater_against
      man_diff <- (goalie_for + skater_for) - (goalie_against + skater_against)
      data[[man_differential_name]] <- man_diff
      strength_state <- rep(NA_character_, n)
      strength_state[!is.na(man_diff) & man_diff == 0]  <- 'even-strength'
      strength_state[!is.na(man_diff) & man_diff >  0]  <- 'power-play'
      strength_state[!is.na(man_diff) & man_diff <  0]  <- 'penalty-kill'
      data[[strength_state_name]] <- strength_state
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

flag_is_home <- function(
  data,
  game_id_name              = 'gameId',
  event_owner_team_id_name  = 'eventOwnerTeamId',
  is_home_name              = 'isHome'
) {
  tryCatch(
    expr = {
      games         <- games()
      data_game_id  <- as.character(data[[game_id_name]])
      games_game_id <- as.character(games[['id']])
      idx           <- match(data_game_id, games_game_id)
      home_ids      <- games[['homeTeamId']][idx]
      owner_ids     <- data[[event_owner_team_id_name]]
      is_home       <- rep(NA, length(owner_ids))
      valid         <- !is.na(owner_ids) & !is.na(home_ids)
      if (any(valid)) {
        is_home[valid] <- 
          as.character(owner_ids[valid]) == as.character(home_ids[valid])
      }
      data[[is_home_name]] <- is_home
      data
    },
    error = function(e) {
      message(e)
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

flag_is_rebound <- function(
  data,
  game_id_name           = 'gameId',
  sort_order_name        = 'sortOrder',
  seconds_elapsed_in_game_name   = 'secondsElapsedInGame',
  type_description_name  = 'typeDescKey',
  is_home_name           = 'isHome',
  is_rebound_name        = 'isRebound'
) {
  tryCatch(
    expr = {
      n <- nrow(data)
      game_id    <- as.character(data[[game_id_name]])
      sort_order <- as.numeric(data[[sort_order_name]])
      sec_game   <- as.numeric(data[[seconds_elapsed_in_game_name]])
      is_home <- data[[is_home_name]]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      type <- as.character(data[[type_description_name]])
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
        if (length(idx) == 0) next
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
      data[[is_rebound_name]] <- is_rebound
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

flag_is_rush <- function(
  data,
  game_id_name          = 'gameId',
  sort_order_name       = 'sortOrder',
  seconds_elapsed_in_game_name  = 'secondsElapsedInGame',
  type_description_name = 'typeDescKey',
  is_home_name          = 'isHome',
  zone_code_name        = 'zoneCode',
  is_rush_name          = 'isRush'
) {
  tryCatch(
    expr = {
      n <- nrow(data)
      game_id    <- as.character(data[[game_id_name]])
      sort_order <- as.numeric(data[[sort_order_name]])
      sec_game   <- as.numeric(data[[seconds_elapsed_in_game_name]])
      is_home <- data[[is_home_name]]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      type       <- as.character(data[[type_description_name]])
      zone_owner <- as.character(data[[zone_code_name]])
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
      data[[is_rush_name]] <- is_rush
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

fill_goals_shots <- function(
  data,
  game_id_name                    = 'gameId',
  sort_order_name                 = 'sortOrder',
  is_home_name                    = 'isHome',
  type_description_name           = 'typeDescKey',
  home_goals_name                 = 'homeGoals',
  away_goals_name                 = 'awayGoals',
  home_shots_on_goal_name         = 'homeSOG',
  away_shots_on_goal_name         = 'awaySOG',
  home_fenwick_name               = 'homeFenwick',
  away_fenwick_name               = 'awayFenwick',
  home_corsi_name                 = 'homeCorsi',
  away_corsi_name                 = 'awayCorsi',
  goals_for_name                  = 'goalsFor',
  goals_against_name              = 'goalsAgainst',
  shots_on_goal_for_name          = 'SOGFor',
  shots_on_goal_against_name      = 'SOGAgainst',
  fenwick_for_name                = 'fenwickFor',
  fenwick_against_name            = 'fenwickAgainst',
  corsi_for_name                  = 'corsiFor',
  corsi_against_name              = 'corsiAgainst',
  goal_differential_name          = 'goalDifferential',
  shots_on_goal_differential_name = 'SOGDifferential',
  fenwick_differential_name       = 'fenwickDifferential',
  corsi_differential_name         = 'corsiDifferential'
) {
  tryCatch(
    expr = {
      n <- nrow(data)
      game_id    <- as.character(data[[game_id_name]])
      sort_order <- as.numeric(data[[sort_order_name]])
      is_home    <- data[[is_home_name]]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      type <- as.character(data[[type_description_name]])
      is_goal   <- !is.na(type) & type == 'goal'
      is_sog    <- is_goal | (!is.na(type) & type == 'shot-on-goal')
      is_fen    <- is_sog  | (!is.na(type) & type == 'missed-shot')
      is_corsi  <- is_fen  | (!is.na(type) & type == 'blocked-shot')
      
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
        if (length(idx) == 0) next
        ord <- order(sort_order[idx], na.last = TRUE)
        idx_ord <- idx[ord]
        
        home_goals   <- 0
        away_goals   <- 0
        home_sog     <- 0
        away_sog     <- 0
        home_fen     <- 0
        away_fen     <- 0
        home_corsi   <- 0
        away_corsi   <- 0
        
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
              
              gf  <- home_goals
              ga  <- away_goals
              sf  <- home_sog
              sa  <- away_sog
              ff  <- home_fen
              fa  <- away_fen
              cf  <- home_corsi
              ca  <- away_corsi
              
            } else {
              
              gf  <- away_goals
              ga  <- home_goals
              sf  <- away_sog
              sa  <- home_sog
              ff  <- away_fen
              fa  <- home_fen
              cf  <- away_corsi
              ca  <- home_corsi
              
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
              
              if (is_goal[i])  home_goals <- home_goals + 1
              if (is_sog[i])   home_sog   <- home_sog   + 1
              if (is_fen[i])   home_fen   <- home_fen   + 1
              if (is_corsi[i]) home_corsi <- home_corsi + 1
              
            } else {
              
              if (is_goal[i])  away_goals <- away_goals + 1
              if (is_sog[i])   away_sog   <- away_sog   + 1
              if (is_fen[i])   away_fen   <- away_fen   + 1
              if (is_corsi[i]) away_corsi <- away_corsi + 1
              
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
      
      data[[home_goals_name]]                   <- home_goals_vec
      data[[away_goals_name]]                   <- away_goals_vec
      data[[home_shots_on_goal_name]]           <- home_sog_vec
      data[[away_shots_on_goal_name]]           <- away_sog_vec
      data[[home_fenwick_name]]                 <- home_fen_vec
      data[[away_fenwick_name]]                 <- away_fen_vec
      data[[home_corsi_name]]                   <- home_corsi_vec
      data[[away_corsi_name]]                   <- away_corsi_vec
      
      data[[goals_for_name]]                    <- goals_for
      data[[goals_against_name]]                <- goals_against
      data[[shots_on_goal_for_name]]            <- sog_for
      data[[shots_on_goal_against_name]]        <- sog_against
      data[[fenwick_for_name]]                  <- fen_for
      data[[fenwick_against_name]]              <- fen_against
      data[[corsi_for_name]]                    <- corsi_for
      data[[corsi_against_name]]                <- corsi_against
      
      data[[goal_differential_name]]            <- goals_for - goals_against
      data[[shots_on_goal_differential_name]]   <- sog_for   - sog_against
      data[[fenwick_differential_name]]         <- fen_for   - fen_against
      data[[corsi_differential_name]]           <- corsi_for - corsi_against
      
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

normalize_coordinates <- function(
  data,
  is_home_name                     = 'isHome',
  home_team_defending_side_name    = 'homeTeamDefendingSide',
  x_coordinate_name                = 'xCoord',
  y_coordinate_name                = 'yCoord',
  x_coordinate_normalized_name     = 'xCoordNorm',
  y_coordinate_normalized_name     = 'yCoordNorm'
) {
  tryCatch(
    expr = {
      is_home  <- data[[is_home_name]]
      if (!is.logical(is_home)) {
        is_home <- as.logical(is_home)
      }
      home_def <- tolower(as.character(data[[home_team_defending_side_name]]))
      x        <- as.numeric(data[[x_coordinate_name]])
      y        <- as.numeric(data[[y_coordinate_name]])
      n <- length(x)
      mult <- rep(NA_integer_, n)
      valid <- !is.na(is_home) & !is.na(home_def)
      left_idx  <- valid & home_def == 'left'
      if (any(left_idx)) {
        mult[left_idx] <- ifelse(is_home[left_idx],  1, -1)
      }
      right_idx <- valid & home_def == 'right'
      if (any(right_idx)) {
        mult[right_idx] <- ifelse(is_home[right_idx], -1,  1)
      }
      data[[x_coordinate_normalized_name]] <- x * mult
      data[[y_coordinate_normalized_name]] <- y * mult
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

calculate_distance <- function(
  data,
  x_coordinate_normalized_name = 'xCoordNorm',
  y_coordinate_normalized_name = 'yCoordNorm'
) {
  tryCatch(
    expr = {
      x <- as.numeric(data[[x_coordinate_normalized_name]])
      y <- as.numeric(data[[y_coordinate_normalized_name]])
      dx <- 89 - x
      dy <- 0 - y
      distance <- sqrt(dx^2 + dy^2)
      data[['distance']] <- distance
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}

calculate_angle <- function(
  data,
  x_coordinate_normalized_name = 'xCoordNorm',
  y_coordinate_normalized_name = 'yCoordNorm'
) {
  tryCatch(
    expr = {
      x <- as.numeric(data[[x_coordinate_normalized_name]])
      y <- as.numeric(data[[y_coordinate_normalized_name]])
      dx <- 89 - x
      dy <- 0 - y
      angle <- atan2(abs(dy), dx) * 180 / pi
      data[['angle']] <- angle
      data
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data
    }
  )
}
