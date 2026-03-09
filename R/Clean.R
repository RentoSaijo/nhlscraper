#' Strip the game ID into the season ID, game type ID, and game number for all the events (plays) in a play-by-play
#' 
#' `strip_game_id()` strips the game ID into season ID, game type ID, and game number for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] and/or [wsc_play_by_play()] for reference
#' @returns data.frame with one row per event (play) and added columns: `seasonId`, `gameTypeId`, and `gameNumber`
#' @keywords internal

strip_game_id <- function(play_by_play) {
  game                    <- unique(play_by_play$gameId)
  play_by_play$seasonId   <- game %/% 1e6 * 1e4 + game %/% 1e6 + 1
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

.is_short_missed_shot <- function(play_by_play) {
  n <- nrow(play_by_play)
  if (!n) return(logical(0))
  typeDescKey <- if ('typeDescKey' %in% names(play_by_play)) {
    as.character(play_by_play$typeDescKey)
  } else {
    rep(NA_character_, n)
  }
  reason <- if ('reason' %in% names(play_by_play)) {
    trimws(tolower(as.character(play_by_play$reason)))
  } else {
    rep(NA_character_, n)
  }
  !is.na(typeDescKey) & typeDescKey == 'missed-shot' & !is.na(reason) & reason == 'short'
}

.shot_event_mask <- function(play_by_play, types) {
  n <- nrow(play_by_play)
  if (!n) return(logical(0))
  typeDescKey <- if ('typeDescKey' %in% names(play_by_play)) {
    as.character(play_by_play$typeDescKey)
  } else {
    rep(NA_character_, n)
  }
  !.is_short_missed_shot(play_by_play) & !is.na(typeDescKey) & typeDescKey %in% types
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
  is_attempt <- .shot_event_mask(play_by_play, attempt)
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
  is_attempt <- .shot_event_mask(play_by_play, attempt)
  is_source  <- .shot_event_mask(play_by_play, source)
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
#' `normalize_coordinates()` normalizes the x and y coordinates for all the events (plays) in a play-by-play such that they all attack towards +x. If `homeTeamDefendingSide` is not available, the home defending side in period 1 is inferred using `zoneCode`, `isHome`, and `xCoord`.
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
  goal    <- .shot_event_mask(play_by_play, 'goal')
  SOG     <- .shot_event_mask(play_by_play, c('goal', 'shot-on-goal'))
  fenwick <- .shot_event_mask(play_by_play, c('goal', 'shot-on-goal', 'missed-shot'))
  corsi   <- .shot_event_mask(play_by_play, c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot'))
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(play_by_play$sortOrder[idx], na.last = TRUE)]
    is_home <- play_by_play$isHome[idx] %in% TRUE
    is_away <- play_by_play$isHome[idx] %in% FALSE
    hG <- as.integer(goal[idx]    & is_home); aG <- as.integer(goal[idx]    & is_away)
    hS <- as.integer(SOG[idx]     & is_home); aS <- as.integer(SOG[idx]     & is_away)
    hF <- as.integer(fenwick[idx] & is_home); aF <- as.integer(fenwick[idx] & is_away)
    hC <- as.integer(corsi[idx]   & is_home); aC <- as.integer(corsi[idx]   & is_away)
    homeGoals   <- c(0L, utils::head(cumsum(hG), -1L)); awayGoals   <- c(0L, utils::head(cumsum(aG), -1L))
    homeSOG     <- c(0L, utils::head(cumsum(hS), -1L)); awaySOG     <- c(0L, utils::head(cumsum(aS), -1L))
    homeFenwick <- c(0L, utils::head(cumsum(hF), -1L)); awayFenwick <- c(0L, utils::head(cumsum(aF), -1L))
    homeCorsi   <- c(0L, utils::head(cumsum(hC), -1L)); awayCorsi   <- c(0L, utils::head(cumsum(aC), -1L))
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

#' Calculate event-to-event deltas and speeds in normalized x/y, distance, and angle for a play-by-play
#'
#' `calculate_speed()` calculates event-to-event deltas and speeds in normalized x/y, distance, and angle for a play-by-play. Sequences are bounded by faceoffs: each sequence begins at a faceoff, faceoff rows do not look backward across the boundary, and subsequent events are compared to the most recent prior valid-spatial event in the same faceoff-bounded sequence. Shootout and penalty-shot rows (`0101`/`1010`) are left as `NA` and do not serve as anchors for later rows. When multiple events in a sequence share the same recorded second, zero-time denominators are replaced by `1 / n`, where `n` is the number of events in that same second within the sequence.
#'
#' @inheritParams add_on_ice_players
#' @returns data.frame with one row per event (play) and added columns: `dXN`, `dYN`, `dD`, `dA`, `dT`, `dXNdT`, `dYNdT`, `dDdT`, `dAdT`, `eventIdPrev`, `secondsElapsedInSequence`
#' @export

calculate_speed <- function(play_by_play) {
  t <- play_by_play$secondsElapsedInGame
  x <- play_by_play$xCoordNorm
  y <- play_by_play$yCoordNorm
  situationCode <- if ('situationCode' %in% names(play_by_play)) as.character(play_by_play$situationCode) else rep(NA_character_, nrow(play_by_play))
  n <- nrow(play_by_play)
  dXN <- rep(NA_real_, n)
  dYN <- rep(NA_real_, n)
  dD  <- rep(NA_real_, n)
  dA  <- rep(NA_real_, n)
  dT  <- rep(NA_real_, n)
  dXNdT <- rep(NA_real_, n)
  dYNdT <- rep(NA_real_, n)
  dDdT  <- rep(NA_real_, n)
  dAdT  <- rep(NA_real_, n)
  eventIdPrev <- if ('eventId' %in% names(play_by_play)) play_by_play$eventId[rep(NA_integer_, n)] else rep(NA_integer_, n)
  secondsElapsedInSequence <- rep(NA_real_, n)
  is_faceoff <- play_by_play$typeDescKey == 'faceoff'
  is_ps_so <- !is.na(situationCode) & situationCode %in% c('0101', '1010')
  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(t[idx], play_by_play$sortOrder[idx], na.last = TRUE)]
    if (length(idx) <= 1L) next
    m <- length(idx)
    t_ord <- t[idx]
    valid_spatial <- !is.na(x[idx]) & !is.na(y[idx]) &
      !is.na(play_by_play$distance[idx]) & !is.na(play_by_play$angle[idx]) &
      !is_ps_so[idx]
    prev_pos <- rep(NA_integer_, m)
    seq_id <- rep(NA_integer_, m)
    last_valid_since_faceoff <- NA_integer_
    current_seq <- 0L
    seq_start_time <- NA_real_
    for (k in seq_len(m)) {
      i <- idx[k]
      if (is_faceoff[i]) {
        current_seq <- current_seq + 1L
        seq_start_time <- t[i]
        seq_id[k] <- current_seq
        prev_pos[k] <- NA_integer_
        if (!is_ps_so[i] && !is.na(seq_start_time) && !is.na(t[i])) secondsElapsedInSequence[i] <- t[i] - seq_start_time
      } else if (current_seq > 0L) {
        seq_id[k] <- current_seq
        if (!is_ps_so[i]) prev_pos[k] <- last_valid_since_faceoff
        if (!is_ps_so[i] && !is.na(seq_start_time) && !is.na(t[i])) secondsElapsedInSequence[i] <- t[i] - seq_start_time
      }
      if (is_faceoff[i]) {
        last_valid_since_faceoff <- if (valid_spatial[k]) k else NA_integer_
      } else if (valid_spatial[k]) {
        last_valid_since_faceoff <- k
      }
    }
    curr_k <- which(!is.na(prev_pos))
    if (!length(curr_k)) next
    curr <- idx[curr_k]
    prev <- idx[prev_pos[curr_k]]
    dt <- t[curr] - t[prev]
    dx <- x[curr] - x[prev]
    dy <- y[curr] - y[prev]
    dd <- play_by_play$distance[curr] - play_by_play$distance[prev]
    da <- play_by_play$angle[curr]    - play_by_play$angle[prev]
    dT[curr]  <- dt
    dXN[curr] <- dx
    dYN[curr] <- dy
    dD[curr]  <- dd
    dA[curr]  <- da
    if ('eventId' %in% names(play_by_play)) eventIdPrev[curr] <- play_by_play$eventId[prev]
    ok <- !is.na(dt) & dt >= 0
    j  <- which(ok)
    if (length(j)) {
      cc <- curr[j]
      denom <- dt[j]
      zero_dt <- which(denom == 0)
      if (length(zero_dt)) {
        zero_curr_k <- curr_k[j[zero_dt]]
        denom[zero_dt] <- vapply(
          zero_curr_k,
          FUN.VALUE = numeric(1),
          function(pos) {
            same_second <- seq_id == seq_id[pos] & t_ord == t_ord[pos]
            1 / sum(same_second, na.rm = TRUE)
          }
        )
      }
      dXNdT[cc] <- dx[j] / denom
      dYNdT[cc] <- dy[j] / denom
      dDdT[cc]  <- dd[j] / denom
      dAdT[cc]  <- da[j] / denom
    }
  }
  play_by_play$dXN   <- dXN
  play_by_play$dYN   <- dYN
  play_by_play$dD    <- dD
  play_by_play$dA    <- dA
  play_by_play$dT    <- dT
  play_by_play$dXNdT <- dXNdT
  play_by_play$dYNdT <- dYNdT
  play_by_play$dDdT  <- dDdT
  play_by_play$dAdT  <- dAdT
  play_by_play$eventIdPrev <- eventIdPrev
  play_by_play$secondsElapsedInSequence <- secondsElapsedInSequence
  after  <- match('angle', names(play_by_play))
  insert <- c('dXN', 'dYN', 'dD', 'dA', 'dT', 'dXNdT', 'dYNdT', 'dDdT', 'dAdT', 'eventIdPrev')
  nms    <- names(play_by_play)
  play_by_play <- play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
  nms <- names(play_by_play)
  if ('secondsElapsedInPeriodSinceLastShiftAgainst' %in% nms) {
    keep <- nms[nms != 'secondsElapsedInSequence']
    after <- match('secondsElapsedInPeriodSinceLastShiftAgainst', keep)
    play_by_play[, c(keep[seq_len(after)], 'secondsElapsedInSequence', keep[(after + 1L):length(keep)])]
  } else {
    play_by_play
  }
}

#' Add shooter biometrics to (a) play-by-play(s)
#'
#' `add_shooter_biometrics()` adds shooter biometrics (height, weight, hand, age at game date, and position) to (a) play-by-play(s) for shot attempts.
#'
#' @inheritParams add_on_ice_players
#' @returns data.frame with one row per event (play) and added columns: `shooterHeight`, `shooterWeight`, `shooterHandCode`, `shooterAge`, and `shooterPositionCode`
#' @export

add_shooter_biometrics <- function(play_by_play) {
  bios  <- players()
  games <- games()
  shooterId <- ifelse(!is.na(play_by_play$scoringPlayerId), play_by_play$scoringPlayerId, play_by_play$shootingPlayerId)
  gidx <- match(play_by_play$gameId, games$gameId)
  gd   <- as.Date(games$gameDate[gidx])
  pidx <- match(shooterId, bios$playerId)
  ht   <- bios$height[pidx]
  wt   <- bios$weight[pidx]
  hand <- bios$handCode[pidx]
  pos  <- bios$positionCode[pidx]
  bd   <- as.Date(bios$birthDate[pidx])
  gy   <- as.integer(format(gd, '%Y'))
  by   <- as.integer(format(bd, '%Y'))
  gm   <- as.integer(format(gd, '%m'))
  bm   <- as.integer(format(bd, '%m'))
  gD   <- as.integer(format(gd, '%d'))
  bD   <- as.integer(format(bd, '%d'))
  had_bday <- (gm > bm) | (gm == bm & gD >= bD)
  age  <- (gy - by) - ifelse(had_bday, 0L, 1L)
  age[is.na(gd) | is.na(bd)] <- NA_integer_
  play_by_play$shooterHeight       <- ht
  play_by_play$shooterWeight       <- wt
  play_by_play$shooterHandCode     <- hand
  play_by_play$shooterPositionCode <- pos
  play_by_play$shooterAge          <- age
  play_by_play
}

#' Add goalie biometrics to (a) play-by-play(s)
#'
#' `add_goalie_biometrics()` adds goalie biometrics (height, weight, hand, and age at game date) to (a) play-by-play(s) for shot attempts. If `goalieInNetId` is missing on a row, the added goalie biometrics are left as `NA`.
#'
#' @inheritParams add_on_ice_players
#' @returns data.frame with one row per event (play) and added columns: `goalieHeight`, `goalieWeight`, `goalieHandCode`, and `goalieAge`
#' @export

add_goalie_biometrics <- function(play_by_play) {
  bios  <- players()
  games <- games()
  goalieId <- play_by_play$goalieInNetId
  gidx <- match(play_by_play$gameId, games$gameId)
  gd   <- as.Date(games$gameDate[gidx])
  pidx <- match(goalieId, bios$playerId)
  ht   <- bios$height[pidx]
  wt   <- bios$weight[pidx]
  hand <- bios$handCode[pidx]
  bd   <- as.Date(bios$birthDate[pidx])
  gy   <- as.integer(format(gd, '%Y'))
  by   <- as.integer(format(bd, '%Y'))
  gm   <- as.integer(format(gd, '%m'))
  bm   <- as.integer(format(bd, '%m'))
  gD   <- as.integer(format(gd, '%d'))
  bD   <- as.integer(format(bd, '%d'))
  had_bday <- (gm > bm) | (gm == bm & gD >= bD)
  age <- (gy - by) - ifelse(had_bday, 0L, 1L)
  age[is.na(gd) | is.na(bd)]  <- NA_integer_
  play_by_play$goalieHeight   <- ht
  play_by_play$goalieWeight   <- wt
  play_by_play$goalieHandCode <- hand
  play_by_play$goalieAge      <- age
  play_by_play
}

.normalize_on_ice_situation_code <- function(x) {
  x <- as.character(x)
  ok <- !is.na(x) & grepl('^[0-9]{1,4}$', x)
  out <- rep(NA_character_, length(x))
  out[ok] <- sprintf('%04s', x[ok])
  gsub(' ', '0', out, fixed = TRUE)
}

.on_ice_int_col <- function(df, name) {
  if (name %in% names(df)) as.integer(df[[name]]) else rep(NA_integer_, nrow(df))
}

.on_ice_lgl_col <- function(df, name) {
  if (name %in% names(df)) as.logical(df[[name]]) else rep(NA, nrow(df))
}

.on_ice_list_pick <- function(home, away, is_home, na_value) {
  n <- length(is_home)
  out <- vector('list', n)
  home_idx <- which(is_home %in% TRUE)
  away_idx <- which(is_home %in% FALSE)
  na_idx   <- setdiff(seq_len(n), c(home_idx, away_idx))
  if (length(home_idx)) out[home_idx] <- home[home_idx]
  if (length(away_idx)) out[away_idx] <- away[away_idx]
  if (length(na_idx)) out[na_idx] <- rep(list(na_value), length(na_idx))
  out
}

.infer_on_ice_team_ids <- function(play_by_play, shift_chart) {
  map <- play_by_play[!is.na(play_by_play$eventOwnerTeamId) & !is.na(play_by_play$isHome), c('gameId', 'eventOwnerTeamId', 'isHome')]
  map <- unique(map)
  games <- unique(play_by_play$gameId)
  out <- data.frame(
    gameId = games,
    homeTeamId = rep(NA_integer_, length(games)),
    awayTeamId = rep(NA_integer_, length(games))
  )
  if (nrow(map)) {
    home_map <- aggregate(eventOwnerTeamId ~ gameId, data = map[map$isHome %in% TRUE, ], FUN = function(x) x[1L])
    away_map <- aggregate(eventOwnerTeamId ~ gameId, data = map[map$isHome %in% FALSE, ], FUN = function(x) x[1L])
    out$homeTeamId[match(home_map$gameId, out$gameId)] <- as.integer(home_map$eventOwnerTeamId)
    out$awayTeamId[match(away_map$gameId, out$gameId)] <- as.integer(away_map$eventOwnerTeamId)
  }
  if (nrow(shift_chart)) {
    team_split <- split(as.integer(shift_chart$teamId), shift_chart$gameId)
    for (g in names(team_split)) {
      idx <- match(as.integer(g), out$gameId)
      if (is.na(idx)) next
      teams <- sort(unique(stats::na.omit(team_split[[g]])))
      if (length(teams) != 2L) next
      if (is.na(out$homeTeamId[idx]) && !is.na(out$awayTeamId[idx])) {
        out$homeTeamId[idx] <- teams[teams != out$awayTeamId[idx]][1L]
      }
      if (is.na(out$awayTeamId[idx]) && !is.na(out$homeTeamId[idx])) {
        out$awayTeamId[idx] <- teams[teams != out$homeTeamId[idx]][1L]
      }
    }
  }
  if (anyNA(out$homeTeamId) || anyNA(out$awayTeamId)) {
    stop('Unable to infer home/away team IDs for all games in play_by_play.', call. = FALSE)
  }
  out
}

#' Add on-ice player IDs to a play-by-play by merging with shift charts
#' 
#' `add_on_ice_players()` merges a play-by-play with a shift chart to determine which players are on the ice at each event. It adds home- and away-team on-ice player ID lists, event-perspective for/against player ID lists, elapsed time in the current shift for each listed player, and elapsed time since the end of the player's prior shift within the same period. For the first shift of a period, the "since last shift" value is set to `300 + secondsElapsedInPeriod`. For shootout and penalty-shot rows (where `situationCode` is either `0101` or `1010`), the elapsed-time list-columns are returned as `NA`.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()], [gc_play_by_plays()], [wsc_play_by_play()], or [wsc_play_by_plays()] for reference; the original columns must exist
#' @param shift_chart data.frame of shift chart(s); see [shift_chart()] or [shift_charts()] for reference; the original columns must exist
#' @returns data.frame with one row per event (play) and added list-columns:
#' `homePlayerIds`, `awayPlayerIds`, `playerIdsFor`, `playerIdsAgainst`, `homeSkaterPlayerIds`, `awaySkaterPlayerIds`, `skaterPlayerIdsFor`, `skaterPlayerIdsAgainst`, `homeGoaliePlayerId`, `awayGoaliePlayerId`, `goaliePlayerIdFor`, `goaliePlayerIdAgainst`, `homeSecondsElapsedInShift`, `awaySecondsElapsedInShift`, `secondsElapsedInShiftFor`, `secondsElapsedInShiftAgainst`, `homeSecondsElapsedInPeriodSinceLastShift`, `awaySecondsElapsedInPeriodSinceLastShift`, `secondsElapsedInPeriodSinceLastShiftFor`, and `secondsElapsedInPeriodSinceLastShiftAgainst`
#' @examples
#' # May take >5s, so skip.
#' \donttest{gc_pbp_enhanced <- add_on_ice_players(gc_pbp(), shift_chart())}
#' @export

add_on_ice_players <- function(play_by_play = NULL, shift_chart = NULL) {
  fn_env <- parent.env(environment())
  if (is.null(play_by_play)) {
    play_by_play <- get('gc_pbp', mode = 'function', envir = fn_env)()
  }
  if (is.null(shift_chart)) {
    shift_chart <- get('shift_chart', mode = 'function', envir = fn_env)()
  }
  required_pbp <- c(
    'gameId', 'period', 'sortOrder', 'secondsElapsedInPeriod', 'typeDescKey',
    'eventOwnerTeamId', 'isHome', 'homeSkaterCount', 'awaySkaterCount',
    'homeIsEmptyNet', 'awayIsEmptyNet'
  )
  required_shift <- c(
    'gameId', 'teamId', 'playerId', 'period',
    'startSecondsElapsedInPeriod', 'endSecondsElapsedInPeriod'
  )
  missing_pbp <- setdiff(required_pbp, names(play_by_play))
  missing_shift <- setdiff(required_shift, names(shift_chart))
  if (length(missing_pbp)) {
    stop(
      sprintf(
        'play_by_play is missing required column(s): %s',
        paste(missing_pbp, collapse = ', ')
      ),
      call. = FALSE
    )
  }
  if (length(missing_shift)) {
    stop(
      sprintf(
        'shift_chart is missing required column(s): %s',
        paste(missing_shift, collapse = ', ')
      ),
      call. = FALSE
    )
  }

  n <- nrow(play_by_play)
  if (!n) {
    empty_int_list <- vector('list', 0L)
    empty_real_list <- vector('list', 0L)
    cols <- c(
      'homePlayerIds', 'awayPlayerIds', 'playerIdsFor', 'playerIdsAgainst',
      'homeSkaterPlayerIds', 'awaySkaterPlayerIds', 'skaterPlayerIdsFor',
      'skaterPlayerIdsAgainst', 'homeGoaliePlayerId', 'awayGoaliePlayerId',
      'goaliePlayerIdFor', 'goaliePlayerIdAgainst',
      'homeSecondsElapsedInShift', 'awaySecondsElapsedInShift',
      'secondsElapsedInShiftFor', 'secondsElapsedInShiftAgainst',
      'homeSecondsElapsedInPeriodSinceLastShift',
      'awaySecondsElapsedInPeriodSinceLastShift',
      'secondsElapsedInPeriodSinceLastShiftFor',
      'secondsElapsedInPeriodSinceLastShiftAgainst'
    )
    for (nm in cols) {
      play_by_play[[nm]] <- if (grepl('SecondsElapsed', nm)) empty_real_list else empty_int_list
    }
    return(play_by_play)
  }

  bios <- players()
  if (!nrow(bios) || !all(c('playerId', 'positionCode') %in% names(bios))) {
    stop(
      'Unable to retrieve players() data needed to identify goalies.',
      call. = FALSE
    )
  }
  goalie_ids <- sort(unique(as.integer(bios$playerId[bios$positionCode == 'G'])))
  goalie_ids <- goalie_ids[!is.na(goalie_ids)]

  situation_code <- .normalize_on_ice_situation_code(play_by_play$situationCode)
  type_map <- c(
    'faceoff' = 1L,
    'hit' = 2L,
    'shot-on-goal' = 3L,
    'giveaway' = 4L,
    'missed-shot' = 5L,
    'blocked-shot' = 6L,
    'penalty' = 7L,
    'goal' = 8L,
    'delayed-penalty' = 9L,
    'takeaway' = 10L,
    'failed-shot-attempt' = 11L
  )
  type_code <- unname(type_map[as.character(play_by_play$typeDescKey)])
  type_code[is.na(type_code)] <- 0L
  is_special <- !is.na(situation_code) &
    situation_code %in% c('0101', '1010') &
    type_code %in% c(3L, 5L, 8L, 11L)

  team_ids <- .infer_on_ice_team_ids(play_by_play, shift_chart)
  play_by_play$homeTeamId <- team_ids$homeTeamId[match(play_by_play$gameId, team_ids$gameId)]
  play_by_play$awayTeamId <- team_ids$awayTeamId[match(play_by_play$gameId, team_ids$gameId)]

  shift_chart <- shift_chart[shift_chart$gameId %in% play_by_play$gameId, ]
  shift_chart <- shift_chart[
    !is.na(shift_chart$gameId) &
      !is.na(shift_chart$teamId) &
      !is.na(shift_chart$playerId) &
      !is.na(shift_chart$period) &
      !is.na(shift_chart$startSecondsElapsedInPeriod) &
      !is.na(shift_chart$endSecondsElapsedInPeriod),
  ]
  shift_chart$isGoalie <- as.integer(shift_chart$playerId) %in% goalie_ids
  if (nrow(shift_chart)) {
    ord_shift <- order(
      as.integer(shift_chart$gameId),
      as.integer(shift_chart$period),
      as.integer(shift_chart$teamId),
      as.integer(shift_chart$playerId),
      as.integer(shift_chart$startSecondsElapsedInPeriod),
      as.integer(shift_chart$endSecondsElapsedInPeriod)
    )
    shift_chart <- shift_chart[ord_shift, ]
  }

  event_order <- order(
    as.integer(play_by_play$gameId),
    as.integer(play_by_play$sortOrder),
    seq_len(n)
  )
  is_home_owner <- ifelse(
    play_by_play$isHome %in% TRUE,
    1L,
    ifelse(play_by_play$isHome %in% FALSE, 0L, NA_integer_)
  )
  home_goalie_target <- ifelse(
    .on_ice_lgl_col(play_by_play, 'homeIsEmptyNet') %in% TRUE,
    0L,
    ifelse(
      .on_ice_lgl_col(play_by_play, 'homeIsEmptyNet') %in% FALSE,
      1L,
      NA_integer_
    )
  )
  away_goalie_target <- ifelse(
    .on_ice_lgl_col(play_by_play, 'awayIsEmptyNet') %in% TRUE,
    0L,
    ifelse(
      .on_ice_lgl_col(play_by_play, 'awayIsEmptyNet') %in% FALSE,
      1L,
      NA_integer_
    )
  )

  prepared <- list(
    as.integer(event_order),
    as.integer(play_by_play$gameId),
    as.integer(play_by_play$period),
    as.integer(play_by_play$secondsElapsedInPeriod),
    as.integer(type_code),
    as.logical(is_special),
    as.integer(is_home_owner),
    as.integer(play_by_play$homeTeamId),
    as.integer(play_by_play$awayTeamId),
    as.integer(play_by_play$homeSkaterCount),
    as.integer(play_by_play$awaySkaterCount),
    as.integer(home_goalie_target),
    as.integer(away_goalie_target),
    .on_ice_int_col(play_by_play, 'winningPlayerId'),
    .on_ice_int_col(play_by_play, 'losingPlayerId'),
    .on_ice_int_col(play_by_play, 'hittingPlayerId'),
    .on_ice_int_col(play_by_play, 'hitteePlayerId'),
    .on_ice_int_col(play_by_play, 'shootingPlayerId'),
    .on_ice_int_col(play_by_play, 'scoringPlayerId'),
    .on_ice_int_col(play_by_play, 'playerId'),
    .on_ice_int_col(play_by_play, 'blockingPlayerId'),
    .on_ice_int_col(play_by_play, 'committedByPlayerId'),
    .on_ice_int_col(play_by_play, 'drawnByPlayerId'),
    .on_ice_int_col(play_by_play, 'goalieInNetId'),
    as.integer(shift_chart$gameId),
    as.integer(shift_chart$period),
    as.integer(shift_chart$teamId),
    as.integer(shift_chart$playerId),
    as.integer(shift_chart$startSecondsElapsedInPeriod),
    as.integer(shift_chart$endSecondsElapsedInPeriod),
    as.logical(shift_chart$isGoalie),
    as.integer(goalie_ids)
  )

  resolved <- .Call('nhlscraper_add_on_ice_players_resolve', prepared)
  na_int <- NA_integer_
  na_real <- NA_real_
  player_ids_for <- .on_ice_list_pick(resolved$homePlayerIds, resolved$awayPlayerIds, play_by_play$isHome, na_int)
  player_ids_against <- .on_ice_list_pick(resolved$awayPlayerIds, resolved$homePlayerIds, play_by_play$isHome, na_int)
  skater_ids_for <- .on_ice_list_pick(resolved$homeSkaterPlayerIds, resolved$awaySkaterPlayerIds, play_by_play$isHome, na_int)
  skater_ids_against <- .on_ice_list_pick(resolved$awaySkaterPlayerIds, resolved$homeSkaterPlayerIds, play_by_play$isHome, na_int)
  goalie_id_for <- .on_ice_list_pick(resolved$homeGoaliePlayerId, resolved$awayGoaliePlayerId, play_by_play$isHome, na_int)
  goalie_id_against <- .on_ice_list_pick(resolved$awayGoaliePlayerId, resolved$homeGoaliePlayerId, play_by_play$isHome, na_int)
  shift_for <- .on_ice_list_pick(resolved$homeSecondsElapsedInShift, resolved$awaySecondsElapsedInShift, play_by_play$isHome, na_real)
  shift_against <- .on_ice_list_pick(resolved$awaySecondsElapsedInShift, resolved$homeSecondsElapsedInShift, play_by_play$isHome, na_real)
  last_for <- .on_ice_list_pick(
    resolved$homeSecondsElapsedInPeriodSinceLastShift,
    resolved$awaySecondsElapsedInPeriodSinceLastShift,
    play_by_play$isHome,
    na_real
  )
  last_against <- .on_ice_list_pick(
    resolved$awaySecondsElapsedInPeriodSinceLastShift,
    resolved$homeSecondsElapsedInPeriodSinceLastShift,
    play_by_play$isHome,
    na_real
  )

  out_cols <- list(
    homePlayerIds = resolved$homePlayerIds,
    awayPlayerIds = resolved$awayPlayerIds,
    playerIdsFor = player_ids_for,
    playerIdsAgainst = player_ids_against,
    homeSkaterPlayerIds = resolved$homeSkaterPlayerIds,
    awaySkaterPlayerIds = resolved$awaySkaterPlayerIds,
    skaterPlayerIdsFor = skater_ids_for,
    skaterPlayerIdsAgainst = skater_ids_against,
    homeGoaliePlayerId = resolved$homeGoaliePlayerId,
    awayGoaliePlayerId = resolved$awayGoaliePlayerId,
    goaliePlayerIdFor = goalie_id_for,
    goaliePlayerIdAgainst = goalie_id_against,
    homeSecondsElapsedInShift = resolved$homeSecondsElapsedInShift,
    awaySecondsElapsedInShift = resolved$awaySecondsElapsedInShift,
    secondsElapsedInShiftFor = shift_for,
    secondsElapsedInShiftAgainst = shift_against,
    homeSecondsElapsedInPeriodSinceLastShift = resolved$homeSecondsElapsedInPeriodSinceLastShift,
    awaySecondsElapsedInPeriodSinceLastShift = resolved$awaySecondsElapsedInPeriodSinceLastShift,
    secondsElapsedInPeriodSinceLastShiftFor = last_for,
    secondsElapsedInPeriodSinceLastShiftAgainst = last_against
  )
  play_by_play$homeTeamId <- NULL
  play_by_play$awayTeamId <- NULL
  existing <- intersect(names(play_by_play), names(out_cols))
  if (length(existing)) {
    play_by_play[existing] <- NULL
  }
  for (nm in names(out_cols)) {
    play_by_play[[nm]] <- out_cols[[nm]]
  }
  play_by_play
}
