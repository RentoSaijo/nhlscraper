#' Strip the game ID into the season ID, game type ID, and game number for all the events (plays) in a play-by-play
#' 
#' `strip_game_id()` strips the game ID into season ID, game type ID, and game number for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] and/or [wsc_play_by_play()] for reference
#' @returns data.frame with one row per event (play) and added columns: `seasonId`, `gameTypeId`, and `gameNumber`
#' @keywords internal

strip_game_id <- function(play_by_play) {
  game                    <- unique(play_by_play$gameId)
  play_by_play$seasonId   <- game %/% 1e6
  play_by_play$gameTypeId <- game %/% 1e4 %% 1e2
  play_by_play$gameNumber <- game %% 1e4
  front                   <- c('gameId', 'eventId', 'seasonId', 'gameTypeId', 'gameNumber', 'sortOrder')
  play_by_play[, c(front, setdiff(names(play_by_play), front))]
}

#' Strip the timestamp and period number into the time elapsed in the period and game for all the events (plays) in a play-by-play
#' 
#' `strip_time_period()` strips the timestamp and period number into the time elapsed in the period and game for all the events (plays) in a play-by-play.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added columns `secondsElapsedInPeriod` and `secondsElapsedInGame`
#' @keywords internal

strip_time_period <- function(play_by_play) {
  isPlayoffs <- play_by_play$gameTypeId == 3
  tp   <- strsplit(play_by_play$timeInPeriod, ':', fixed = TRUE)
  mins <- as.integer(vapply(tp, `[`, '', 1L))
  secs <- as.integer(vapply(tp, `[`, '', 2L))
  elp  <- 60L * mins + secs
  play_by_play$secondsElapsedInPeriod <- elp
  base <- ifelse(
    play_by_play$period <= 3L,
    (play_by_play$period - 1L) * 1200L,
    ifelse(
      isPlayoffs,
      3600L + (play_by_play$period - 4L) * 1200L,
      3600L + (play_by_play$period - 4L) * 300L
    )
  )
  play_by_play$secondsElapsedInGame   <- base + elp
  insert <- c('period', 'timeInPeriod', 'secondsElapsedInPeriod', 'secondsElapsedInGame')
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('sortOrder', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}

#' Strip the situation code into goalie and skater counts, man differential, and strength state for all the events (plays) in a play-by-play by perspective
#' 
#' `strip_situation_code()` strips the situation code into goalie and skater counts for home and away teams, then (from the event owner's perspective) computes man differential and a strength state classification.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added columns: `homeIsEmptyNet`, `awayIsEmptyNet`, `homeSkaterCount`, `awaySkaterCount`, `isEmptyNetFor`, `isEmptyNetAgainst`, `skaterCountFor`, `skaterCountAgainst`, `manDifferential`, and `strengthState`
#' @keywords internal

strip_situation_code <- function(play_by_play) {
  sc_raw       <- as.character(play_by_play$situationCode)
  ok           <- !is.na(sc_raw) & grepl('^[0-9]{1,4}$', sc_raw)
  sc_chr       <- rep(NA_character_, length(sc_raw))
  sc_chr[ok]   <- sprintf('%04s', sc_raw[ok])
  sc_chr[ok]   <- gsub(' ', '0', sc_chr[ok])
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(play_by_play$sortOrder[idx], na.last = TRUE)]
    ps  <- which(play_by_play$typeDescKey[idx] == 'period-start' & is.na(sc_chr[idx]))
    pe  <- which(play_by_play$typeDescKey[idx] == 'period-end'   & is.na(sc_chr[idx]))
    if (length(ps)) sc_chr[idx[ps]] <- sc_chr[idx[ps + 1L]]
    if (length(pe)) sc_chr[idx[pe]] <- sc_chr[idx[pe - 1L]]
    for (k in seq_along(idx)) {
      i <- idx[k]
      if (is.na(sc_chr[i]) && k > 1L) sc_chr[i] <- sc_chr[idx[k - 1L]]
    }
    for (k in length(idx):1L) {
      i <- idx[k]
      if (is.na(sc_chr[i]) && k < length(idx)) sc_chr[i] <- sc_chr[idx[k + 1L]]
    }
  }
  play_by_play$situationCode <- sc_chr
  aG <- as.integer(substr(sc_chr, 1L, 1L))
  aS <- as.integer(substr(sc_chr, 2L, 2L))
  hS <- as.integer(substr(sc_chr, 3L, 3L))
  hG <- as.integer(substr(sc_chr, 4L, 4L))
  play_by_play$homeIsEmptyNet  <- hG == 0L
  play_by_play$awayIsEmptyNet  <- aG == 0L
  play_by_play$homeSkaterCount <- hS
  play_by_play$awaySkaterCount <- aS
  play_by_play$isEmptyNetFor     <- ifelse(
    play_by_play$isHome,
    hG == 0L,
    ifelse(!is.na(play_by_play$isHome), aG == 0L, NA)
  )
  play_by_play$isEmptyNetAgainst <- ifelse(
    play_by_play$isHome,
    aG == 0L,
    ifelse(!is.na(play_by_play$isHome), hG == 0L, NA)
  )
  play_by_play$skaterCountFor     <- ifelse(
    play_by_play$isHome,
    hS,
    ifelse(!is.na(play_by_play$isHome), aS, NA)
  )
  play_by_play$skaterCountAgainst <- ifelse(
    play_by_play$isHome,
    aS,
    ifelse(!is.na(play_by_play$isHome), hS, NA)
  )
  forMen                       <- play_by_play$skaterCountFor + ifelse(play_by_play$isHome, hG, aG)
  agMen                        <- play_by_play$skaterCountAgainst + ifelse(play_by_play$isHome, aG, hG)
  play_by_play$manDifferential <- ifelse(is.na(play_by_play$isHome), NA, forMen - agMen)
  play_by_play$strengthState   <- ifelse(
    is.na(play_by_play$manDifferential),
    NA,
    ifelse(
      play_by_play$manDifferential > 0L,
      'power-play',
      ifelse(play_by_play$manDifferential < 0L, 'penalty-kill', 'even-strength')
    )
  )
  after  <- match('situationCode', names(play_by_play))
  insert <- c(
    'homeIsEmptyNet',
    'awayIsEmptyNet',
    'homeSkaterCount',
    'awaySkaterCount',
    'isEmptyNetFor',
    'isEmptyNetAgainst',
    'skaterCountFor',
    'skaterCountAgainst',
    'manDifferential',
    'strengthState'
  )
  nms <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Flag if the event belongs to the home team or not for all the events (plays) in a play-by-play
#' 
#' `flag_is_home()` flags if the event belongs to the home team or not for all the events (plays) in a play-by-play.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added `isHome` column
#' @keywords internal

flag_is_home <- function(play_by_play) {
  pbp <- play_by_play[order(play_by_play$sortOrder), ]
  n   <- nrow(pbp)
  fill_down <- function(x) {
    if (is.null(x)) return(rep(NA_real_, n))
    x[1L] <- ifelse(is.na(x[1L]), 0, x[1L])
    if (length(x) > 1L) for (i in 2L:length(x)) if (is.na(x[i])) x[i] <- x[i - 1L]
    x
  }
  hs  <- fill_down(pbp$homeScore)
  as  <- fill_down(pbp$awayScore)
  ho  <- fill_down(pbp$homeSOG)
  ao  <- fill_down(pbp$awaySOG)
  dhs <- c(0, diff(hs))
  das <- c(0, diff(as))
  dho <- c(0, diff(ho))
  dao <- c(0, diff(ao))
  inc_home  <- (!is.na(dhs) & dhs > 0) | (!is.na(dho) & dho > 0)
  inc_away  <- (!is.na(das) & das > 0) | (!is.na(dao) & dao > 0)
  homeVotes <- pbp$eventOwnerTeamId[inc_home & !is.na(pbp$eventOwnerTeamId)]
  awayVotes <- pbp$eventOwnerTeamId[inc_away & !is.na(pbp$eventOwnerTeamId)]
  homeId    <- as.integer(names(which.max(table(homeVotes))))
  awayId    <- as.integer(names(which.max(table(awayVotes))))
  play_by_play$isHome <- ifelse(
    play_by_play$eventOwnerTeamId == homeId,
    TRUE,
    ifelse(play_by_play$eventOwnerTeamId == awayId, FALSE, NA)
  )
  insert <- c('eventOwnerTeamId', 'isHome', 'typeCode', 'typeDescKey')
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('secondsElapsedInGame', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}

#' Flag if the shot attempt is a rush attempt or not for all the shots in a play-by-play
#' 
#' `flag_is_rush()` flags whether a shot attempt is a rush attempt, defined as any shot attempt occurring within 4 seconds of a prior event in the neutral or defensive zone with no stoppage in play in between.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added `isRush` column
#' @keywords internal

flag_is_rush <- function(play_by_play) {
  n          <- nrow(play_by_play)
  attempt    <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
  stoppage   <- c('stoppage', 'faceoff', 'period-start', 'period-end', 'game-end')
  is_attempt <- play_by_play$typeDescKey %in% attempt
  is_stop    <- play_by_play$typeDescKey %in% stoppage
  is_nz_dz   <- play_by_play$zoneCode %in% c('N', 'D')
  is_ps_so   <- play_by_play$situationCode %in% c('0101', '1010')
  is_rush    <- rep(NA, n)
  is_rush[is_attempt] <- FALSE
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(play_by_play$secondsElapsedInGame[idx], play_by_play$sortOrder[idx], na.last = TRUE)]

    last_nz_dz_time <- NA_real_
    for (i in idx) {
      if (is_stop[i]) {
        last_nz_dz_time <- NA_real_
        next
      }
      t <- play_by_play$secondsElapsedInGame[i]
      if (is_attempt[i] && !is.na(last_nz_dz_time) && t - last_nz_dz_time <= 4) {
        is_rush[i] <- TRUE
      }
      if (is_nz_dz[i]) {
        last_nz_dz_time <- t
      }
    }
  }
  is_rush[is_attempt & is_ps_so] <- FALSE
  play_by_play$isRush <- is_rush
  after               <- match('angle', names(play_by_play))
  insert              <- c('shotType', 'isRush')
  nms                 <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Flag if the shot attempt is a rebound attempt or creates a rebound for all the shots in a play-by-play
#' 
#' `flag_is_rebound()` flags whether a shot attempt is a rebound attempt (i.e., taken within 3 seconds of a prior blocked, missed, or saved attempt with no stoppage in between), and whether a shot attempt creates a rebound under the same definition.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added columns: `createdRebound` and `isRebound`
#' @keywords internal

flag_is_rebound <- function(play_by_play) {
  n          <- nrow(play_by_play)
  attempt    <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
  source     <- c('shot-on-goal', 'missed-shot', 'blocked-shot')
  stoppage   <- c('stoppage', 'faceoff', 'period-start', 'period-end', 'game-end')
  is_attempt <- play_by_play$typeDescKey %in% attempt
  is_source  <- play_by_play$typeDescKey %in% source
  is_stop    <- play_by_play$typeDescKey %in% stoppage
  is_ps_so   <- play_by_play$situationCode %in% c('0101', '1010')
  is_rebound <- rep(NA, n)
  is_rebound[is_attempt] <- FALSE
  created                <- rep(NA, n)
  created[is_attempt]    <- FALSE
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(play_by_play$secondsElapsedInGame[idx], play_by_play$sortOrder[idx], na.last = TRUE)]
    last_time <- list()
    last_idx  <- list()
    for (i in idx) {
      if (is_stop[i]) {
        last_time <- list()
        last_idx  <- list()
        next
      }
      tid <- as.character(play_by_play$eventOwnerTeamId[i])
      t   <- play_by_play$secondsElapsedInGame[i]
      if (is_attempt[i] && !is.null(last_time[[tid]]) && t - last_time[[tid]] <= 3) {
        is_rebound[i]            <- TRUE
        created[last_idx[[tid]]] <- TRUE
      }
      if (is_source[i]) {
        last_time[[tid]] <- t
        last_idx[[tid]]  <- i
      }
    }
  }
  is_rebound[is_attempt & is_ps_so] <- FALSE
  created[is_attempt  & is_ps_so]   <- FALSE
  play_by_play$createdRebound <- created
  play_by_play$isRebound      <- is_rebound
  after  <- match('isRush', names(play_by_play))
  insert <- c('isRebound', 'createdRebound')
  nms    <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Normalize the x and y coordinates for all the events (plays) in a play-by-play
#' 
#' `normalize_coordinates()` normalizes the x and y coordinates for all the events (plays)
#' in a play-by-play such that they all attack towards +x. If `homeTeamDefendingSide`
#' is not available, the home defending side in period 1 is inferred using `zoneCode`,
#' `isHome`, and `xCoord`.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added columns `xCoordNorm` and `yCoordNorm`
#' @keywords internal

normalize_coordinates <- function(play_by_play) {
  n                       <- nrow(play_by_play)
  play_by_play$xCoordNorm <- NA_real_
  play_by_play$yCoordNorm <- NA_real_
  has_side                <- 'homeTeamDefendingSide' %in% names(play_by_play)
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    if (has_side) {
      side          <- play_by_play$homeTeamDefendingSide[idx][!is.na(play_by_play$homeTeamDefendingSide[idx])][1L]
      home_def_left <- side == 'left'
    } else {
      d_idx         <- idx[
        play_by_play$isHome[idx] & 
          play_by_play$zoneCode[idx] == 'D' &
          play_by_play$period[idx] == 1L & 
          !is.na(play_by_play$xCoord[idx])
      ]
      o_idx         <- idx[
        play_by_play$isHome[idx] & 
          play_by_play$zoneCode[idx] == 'O' &
          play_by_play$period[idx] == 1L & 
          !is.na(play_by_play$xCoord[idx])
      ]
      home_def_left <- if (length(d_idx)) {
        mean(play_by_play$xCoord[d_idx] < 0) >= 0.5
      } else {
        mean(play_by_play$xCoord[o_idx] > 0) >= 0.5
      }
      play_by_play$homeTeamDefendingSide      <- NA_character_
      play_by_play$homeTeamDefendingSide[idx] <- ifelse(home_def_left, 'left', 'right')
    }
    home_att_pos_p1 <- home_def_left
    home_att_pos    <- ifelse(play_by_play$period[idx] %% 2L == 1L, home_att_pos_p1, !home_att_pos_p1)
    att_pos         <- ifelse(play_by_play$isHome[idx], home_att_pos, !home_att_pos)
    flip            <- !att_pos
    play_by_play$xCoordNorm[idx] <- ifelse(flip, -play_by_play$xCoord[idx], play_by_play$xCoord[idx])
    play_by_play$yCoordNorm[idx] <- ifelse(flip, -play_by_play$yCoord[idx], play_by_play$yCoord[idx])
  }
  insert <- c('homeTeamDefendingSide', 'zoneCode', 'xCoord', 'yCoord', 'xCoordNorm', 'yCoordNorm')
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('strengthState', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}

#' Calculate the Euclidean distance from the attacking net for all the events (plays) in a play-by-play
#' 
#' `calculate_distance()` calculates the Euclidean distance from the attacking net for all the events (plays) in a play-by-play.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added `distance` column
#' @keywords internal

calculate_distance <- function(play_by_play) {
  net_x                 <- 89
  play_by_play$distance <- sqrt((net_x - play_by_play$xCoordNorm)^2 + (play_by_play$yCoordNorm)^2)
  after                 <- match('yCoordNorm', names(play_by_play))
  insert                <- 'distance'
  nms                   <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Calculate the Euclidean angle from the attacking net for all the events (plays) in a play-by-play
#' 
#' `calculate_angle()` calculates the Euclidean angle from the attacking net for all the events (plays) in a play-by-play.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added `angle` column
#' @keywords internal

calculate_angle <- function(play_by_play) {
  net_x            <- 89
  dx               <- net_x - play_by_play$xCoordNorm
  play_by_play$angle <- atan2(abs(play_by_play$yCoordNorm), dx) * 180 / pi
  after            <- match('distance', names(play_by_play))
  insert           <- 'angle'
  nms              <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Count the as-of-event goal, shots on goal, Fenwick, and Corsi attempts and differentials for all the events (plays) in a play-by-play by perspective
#' 
#' `count_goals_shots()` counts the as-of-event goal, shots on goal, Fenwick, and Corsi attempts and differentials for all the events (plays) in a play-by-play by perspective.
#' 
#' @inheritParams strip_game_id
#' @returns data.frame with one row per event (play) and added columns: `homeGoals`, `awayGoals`, `homeSOG`, `awaySOG`, `homeFenwick`, `awayFenwick`, `homeCorsi`, `awayCorsi`, `goalsFor`, `goalsAgainst`, `SOGFor`, `SOGAgainst`, `fenwickFor`, `fenwickAgainst`, `corsiFor`, `corsiAgainst`, `goalDifferential`, `SOGDifferential`, `fenwickDifferential`, and `corsiDifferential`
#' @keywords internal

count_goals_shots <- function(play_by_play) {
  goal    <- play_by_play$typeDescKey == 'goal'
  SOG     <- play_by_play$typeDescKey %in% c('goal', 'shot-on-goal')
  fenwick <- play_by_play$typeDescKey %in% c('goal', 'shot-on-goal', 'missed-shot')
  corsi   <- play_by_play$typeDescKey %in% c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(play_by_play$sortOrder[idx], na.last = TRUE)]
    is_home <- play_by_play$isHome[idx] %in% TRUE
    is_away <- play_by_play$isHome[idx] %in% FALSE
    hG <- as.integer(goal[idx]    & is_home); aG <- as.integer(goal[idx]    & is_away)
    hS <- as.integer(SOG[idx]     & is_home); aS <- as.integer(SOG[idx]     & is_away)
    hF <- as.integer(fenwick[idx] & is_home); aF <- as.integer(fenwick[idx] & is_away)
    hC <- as.integer(corsi[idx]   & is_home); aC <- as.integer(corsi[idx]   & is_away)
    homeGoals   <- c(0L, head(cumsum(hG), -1L)); awayGoals   <- c(0L, head(cumsum(aG), -1L))
    homeSOG     <- c(0L, head(cumsum(hS), -1L)); awaySOG     <- c(0L, head(cumsum(aS), -1L))
    homeFenwick <- c(0L, head(cumsum(hF), -1L)); awayFenwick <- c(0L, head(cumsum(aF), -1L))
    homeCorsi   <- c(0L, head(cumsum(hC), -1L)); awayCorsi   <- c(0L, head(cumsum(aC), -1L))
    play_by_play$homeGoals[idx]           <- homeGoals
    play_by_play$awayGoals[idx]           <- awayGoals
    play_by_play$homeSOG[idx]             <- homeSOG
    play_by_play$awaySOG[idx]             <- awaySOG
    play_by_play$homeFenwick[idx]         <- homeFenwick
    play_by_play$awayFenwick[idx]         <- awayFenwick
    play_by_play$homeCorsi[idx]           <- homeCorsi
    play_by_play$awayCorsi[idx]           <- awayCorsi
    play_by_play$goalsFor[idx]            <- ifelse(is_home, homeGoals,   ifelse(is_away, awayGoals,   NA))
    play_by_play$goalsAgainst[idx]        <- ifelse(is_home, awayGoals,   ifelse(is_away, homeGoals,   NA))
    play_by_play$SOGFor[idx]              <- ifelse(is_home, homeSOG,     ifelse(is_away, awaySOG,     NA))
    play_by_play$SOGAgainst[idx]          <- ifelse(is_home, awaySOG,     ifelse(is_away, homeSOG,     NA))
    play_by_play$fenwickFor[idx]          <- ifelse(is_home, homeFenwick, ifelse(is_away, awayFenwick, NA))
    play_by_play$fenwickAgainst[idx]      <- ifelse(is_home, awayFenwick, ifelse(is_away, homeFenwick, NA))
    play_by_play$corsiFor[idx]            <- ifelse(is_home, homeCorsi,   ifelse(is_away, awayCorsi,   NA))
    play_by_play$corsiAgainst[idx]        <- ifelse(is_home, awayCorsi,   ifelse(is_away, homeCorsi,   NA))
    play_by_play$goalDifferential[idx]    <- play_by_play$goalsFor[idx]   - play_by_play$goalsAgainst[idx]
    play_by_play$SOGDifferential[idx]     <- play_by_play$SOGFor[idx]     - play_by_play$SOGAgainst[idx]
    play_by_play$fenwickDifferential[idx] <- play_by_play$fenwickFor[idx] - play_by_play$fenwickAgainst[idx]
    play_by_play$corsiDifferential[idx]   <- play_by_play$corsiFor[idx]   - play_by_play$corsiAgainst[idx]
  }
  insert <- c(
    'homeGoals', 'awayGoals', 'homeSOG', 'awaySOG', 'homeFenwick', 'awayFenwick', 'homeCorsi', 'awayCorsi',
    'goalsFor', 'goalsAgainst', 'SOGFor', 'SOGAgainst', 'fenwickFor', 'fenwickAgainst', 'corsiFor', 'corsiAgainst',
    'goalDifferential', 'SOGDifferential', 'fenwickDifferential', 'corsiDifferential'
  )
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('createdRebound', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}
