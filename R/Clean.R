# Public helpers ----------------------------------------------------------

#' Add event-to-event deltas to a play-by-play
#'
#' `add_deltas()` adds event-to-event deltas in raw and normalized x/y,
#' distance, and angle for a play-by-play. Sequences are bounded by faceoffs:
#' each sequence begins at a faceoff, faceoff rows do not look backward across
#' the boundary, and subsequent events are compared to the most recent prior
#' valid-spatial event in the same faceoff-bounded sequence. Shootout and
#' penalty-shot rows (`0101`/`1010`) are left as `NA` and do not serve as
#' anchors for later rows. When multiple events in a sequence share the same
#' recorded second, zero-time denominators used internally are replaced by
#' `1 / n`, where `n` is the number of events in that same second within the
#' sequence.
#'
#' @param play_by_play data.frame of play-by-play(s) using the current public schema returned by [gc_play_by_play()], [gc_play_by_plays()], [wsc_play_by_play()], or [wsc_play_by_plays()]
#' @returns data.frame with one row per event (play) and added columns: `eventIdPrev`, `secondsElapsedInSequence`, `dSecondsElapsedInSequence`, `dXCoord`, `dYCoord`, `dXCoordNorm`, `dYCoordNorm`, `dDistance`, `dAngle`, `dXCoordPerSecond`, `dYCoordPerSecond`, `dXCoordNormPerSecond`, `dYCoordNormPerSecond`, `dDistancePerSecond`, `dAnglePerSecond`
#' @export
add_deltas <- function(play_by_play) {
  delta_ctx <- .compute_pbp_deltas(play_by_play)
  out <- .apply_pbp_delta_columns(play_by_play, delta_ctx)
  attr(out, 'delta_context') <- delta_ctx
  out
}

#' Build an empty play-by-play delta context
#'
#' `.empty_pbp_delta_context()` allocates an empty delta context sized to the
#' number of play-by-play rows.
#'
#' @param n integer row count
#' @returns named list of empty delta vectors
#' @keywords internal
.empty_pbp_delta_context <- function(n) {
  list(
    eventIdPrev = rep(NA_integer_, n),
    secondsElapsedInSequence = rep(NA_real_, n),
    dSecondsElapsedInSequence = rep(NA_real_, n),
    dXCoord = rep(NA_real_, n),
    dYCoord = rep(NA_real_, n),
    dXCoordNorm = rep(NA_real_, n),
    dYCoordNorm = rep(NA_real_, n),
    dDistance = rep(NA_real_, n),
    dAngle = rep(NA_real_, n),
    dXCoordPerSecond = rep(NA_real_, n),
    dYCoordPerSecond = rep(NA_real_, n),
    dXCoordNormPerSecond = rep(NA_real_, n),
    dYCoordNormPerSecond = rep(NA_real_, n),
    dDistancePerSecond = rep(NA_real_, n),
    dAnglePerSecond = rep(NA_real_, n)
  )
}

#' List public delta column names
#'
#' `.pbp_delta_public_cols()` returns the public-facing delta columns inserted
#' by [add_deltas()].
#'
#' @returns character vector of public delta column names
#' @keywords internal
.pbp_delta_public_cols <- function() {
  c(
    'eventIdPrev',
    'secondsElapsedInSequence',
    'dSecondsElapsedInSequence',
    'dXCoord',
    'dYCoord',
    'dXCoordNorm',
    'dYCoordNorm',
    'dDistance',
    'dAngle',
    'dXCoordPerSecond',
    'dYCoordPerSecond',
    'dXCoordNormPerSecond',
    'dYCoordNormPerSecond',
    'dDistancePerSecond',
    'dAnglePerSecond'
  )
}

#' Compute play-by-play deltas in R
#'
#' `.compute_pbp_deltas_in_r()` is the pure-R fallback for event-to-event delta
#' calculations.
#'
#' @inheritParams add_deltas
#' @returns named list containing delta context vectors
#' @keywords internal
.compute_pbp_deltas_in_r <- function(play_by_play) {
  n <- nrow(play_by_play)
  out <- .empty_pbp_delta_context(n)
  if (!n) {
    return(out)
  }

  t <- play_by_play$secondsElapsedInGame
  x_raw <- play_by_play$xCoord
  y_raw <- play_by_play$yCoord
  x_norm <- play_by_play$xCoordNorm
  y_norm <- play_by_play$yCoordNorm
  distance <- play_by_play$distance
  angle <- play_by_play$angle
  event_id <- as.integer(play_by_play$eventId)
  situation_code <- as.character(play_by_play$situationCode)
  is_faceoff <- play_by_play$eventTypeDescKey == 'faceoff'
  is_ps_so <- !is.na(situation_code) & situation_code %in% c('0101', '1010')

  for (g in unique(play_by_play$gameId)) {
    idx <- which(play_by_play$gameId == g)
    idx <- idx[order(t[idx], play_by_play$sortOrder[idx], na.last = TRUE)]
    if (!length(idx)) {
      next
    }
    m <- length(idx)
    t_ord <- t[idx]
    valid_spatial <- !is.na(x_norm[idx]) & !is.na(y_norm[idx]) &
      !is.na(distance[idx]) & !is.na(angle[idx]) &
      !is_ps_so[idx]
    prev_pos <- rep(NA_integer_, m)
    seq_id <- rep(NA_integer_, m)
    same_second_count <- rep(NA_integer_, m)
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
        if (!is_ps_so[i] && !is.na(seq_start_time) && !is.na(t[i])) {
          out$secondsElapsedInSequence[i] <- t[i] - seq_start_time
        }
      } else if (current_seq > 0L) {
        seq_id[k] <- current_seq
        if (!is_ps_so[i]) {
          prev_pos[k] <- last_valid_since_faceoff
        }
        if (!is_ps_so[i] && !is.na(seq_start_time) && !is.na(t[i])) {
          out$secondsElapsedInSequence[i] <- t[i] - seq_start_time
        }
      }
      if (is_faceoff[i]) {
        last_valid_since_faceoff <- if (valid_spatial[k]) k else NA_integer_
      } else if (valid_spatial[k]) {
        last_valid_since_faceoff <- k
      }
    }

    k <- 1L
    while (k <= m) {
      same_seq <- if (is.na(seq_id[k])) is.na(seq_id) else seq_id == seq_id[k]
      same_time <- if (is.na(t_ord[k])) is.na(t_ord) else t_ord == t_ord[k]
      same_second <- same_seq & same_time
      same_second_count[same_second] <- sum(same_second, na.rm = TRUE)
      k <- max(which(same_second)) + 1L
    }

    curr_k <- which(!is.na(prev_pos))
    if (!length(curr_k)) {
      next
    }
    curr <- idx[curr_k]
    prev <- idx[prev_pos[curr_k]]
    dt <- t[curr] - t[prev]
    dx_raw <- x_raw[curr] - x_raw[prev]
    dy_raw <- y_raw[curr] - y_raw[prev]
    dx_norm <- x_norm[curr] - x_norm[prev]
    dy_norm <- y_norm[curr] - y_norm[prev]
    dd <- distance[curr] - distance[prev]
    da <- angle[curr] - angle[prev]

    out$dSecondsElapsedInSequence[curr] <- dt
    out$dXCoord[curr] <- dx_raw
    out$dYCoord[curr] <- dy_raw
    out$dXCoordNorm[curr] <- dx_norm
    out$dYCoordNorm[curr] <- dy_norm
    out$dDistance[curr] <- dd
    out$dAngle[curr] <- da
    out$eventIdPrev[curr] <- event_id[prev]

    ok <- !is.na(dt) & dt >= 0
    j <- which(ok)
    if (length(j)) {
      cc <- curr[j]
      denom <- dt[j]
      zero_dt <- which(denom == 0)
      if (length(zero_dt)) {
        denom[zero_dt] <- 1 / same_second_count[curr_k[j[zero_dt]]]
      }
      out$dXCoordPerSecond[cc] <- dx_raw[j] / denom
      out$dYCoordPerSecond[cc] <- dy_raw[j] / denom
      out$dXCoordNormPerSecond[cc] <- dx_norm[j] / denom
      out$dYCoordNormPerSecond[cc] <- dy_norm[j] / denom
      out$dDistancePerSecond[cc] <- dd[j] / denom
      out$dAnglePerSecond[cc] <- da[j] / denom
    }
  }

  out
}

#' Compute play-by-play deltas with native fallback
#'
#' `.compute_pbp_deltas()` validates the public schema, then uses the native
#' delta routine when available and falls back to R otherwise.
#'
#' @inheritParams add_deltas
#' @returns named list containing delta context vectors
#' @keywords internal
.compute_pbp_deltas <- function(play_by_play) {
  .require_public_pbp_columns(
    play_by_play,
    c(
      'gameId', 'eventId', 'sortOrder', 'secondsElapsedInGame',
      'eventTypeDescKey', 'situationCode', 'xCoord', 'yCoord',
      'xCoordNorm', 'yCoordNorm', 'distance', 'angle'
    ),
    'add_deltas'
  )
  n <- nrow(play_by_play)
  if (!n) {
    return(.empty_pbp_delta_context(0))
  }
  situation_code <- as.character(play_by_play$situationCode)
  if (!.ensure_local_native_symbol('nhlscraper_pbp_deltas')) {
    return(.compute_pbp_deltas_in_r(play_by_play))
  }
  tryCatch(
    .Call('nhlscraper_pbp_deltas', list(
      as.integer(order(
        play_by_play$gameId,
        play_by_play$secondsElapsedInGame,
        play_by_play$sortOrder,
        seq_len(n),
        na.last = TRUE
      )),
      as.integer(play_by_play$gameId),
      as.integer(play_by_play$eventId),
      as.double(play_by_play$secondsElapsedInGame),
      as.double(play_by_play$xCoord),
      as.double(play_by_play$yCoord),
      as.double(play_by_play$xCoordNorm),
      as.double(play_by_play$yCoordNorm),
      as.double(play_by_play$distance),
      as.double(play_by_play$angle),
      as.logical(play_by_play$eventTypeDescKey == 'faceoff'),
      as.logical(!is.na(situation_code) & situation_code %in% c('0101', '1010'))
    )),
    error = function(e) .compute_pbp_deltas_in_r(play_by_play)
  )
}

#' Attach delta context columns to play-by-play
#'
#' `.apply_pbp_delta_columns()` inserts computed delta columns into a
#' play-by-play and reorders them into the public schema.
#'
#' @inheritParams add_deltas
#' @param delta_ctx named list returned by `.compute_pbp_deltas()`
#' @returns data.frame with public delta columns inserted
#' @keywords internal
.apply_pbp_delta_columns <- function(play_by_play, delta_ctx) {
  public_cols <- .pbp_delta_public_cols()
  legacy_cols <- c(
    'dXN', 'dYN', 'dD', 'dA', 'dT',
    'dXNdT', 'dYNdT', 'dDdT', 'dAdT'
  )
  keep <- setdiff(names(play_by_play), c(public_cols, legacy_cols))
  play_by_play <- play_by_play[, keep, drop = FALSE]
  for (nm in public_cols) {
    play_by_play[[nm]] <- delta_ctx[[nm]]
  }
  after <- match('angle', names(play_by_play))
  insert <- public_cols
  nms <- names(play_by_play)
  play_by_play <- play_by_play[, c(
    nms[seq_len(after)],
    insert,
    setdiff(nms[-seq_len(after)], insert)
  ), drop = FALSE]
  nms <- names(play_by_play)
  anchor_cols <- grep(
    '(^secondsElapsedInPeriodSinceLastShiftAgainst$|SecondsElapsedInPeriodSinceLastShiftAgainst$)',
    nms,
    value = TRUE
  )
  if (length(anchor_cols)) {
    keep <- nms[nms != 'secondsElapsedInSequence']
    after <- max(match(anchor_cols, keep, nomatch = 0L))
    tail_cols <- if (after < length(keep)) {
      keep[(after + 1L):length(keep)]
    } else {
      character()
    }
    play_by_play <- play_by_play[, c(
      keep[seq_len(after)],
      'secondsElapsedInSequence',
      tail_cols
    ), drop = FALSE]
  }
  play_by_play
}

#' Add shooter biometrics to (a) play-by-play(s)
#'
#' `add_shooter_biometrics()` adds shooter biometrics (height, weight, hand, age at game date, and position) to (a) play-by-play(s) for shot attempts.
#'
#' @param play_by_play data.frame of play-by-play(s) using the current public schema returned by [gc_play_by_play()], [gc_play_by_plays()], [wsc_play_by_play()], or [wsc_play_by_plays()]
#' @returns data.frame with one row per event (play) and added columns: `shooterHeight`, `shooterWeight`, `shooterHandCode`, `shooterAge`, and `shooterPositionCode`
#' @export

add_shooter_biometrics <- function(play_by_play) {
  .require_public_pbp_columns(
    play_by_play,
    c('gameId', 'shootingPlayerId', 'scoringPlayerId'),
    'add_shooter_biometrics'
  )
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
#' `add_goalie_biometrics()` adds goalie biometrics (height, weight, hand, and age at game date) to (a) play-by-play(s) for shot attempts. Goalie identity is resolved from `goalieInNetId` first and `goaliePlayerIdAgainst` second. If neither is available on a row, the added goalie biometrics are left as `NA`.
#'
#' @param play_by_play data.frame of play-by-play(s) using the current public schema returned by [gc_play_by_play()], [gc_play_by_plays()], [wsc_play_by_play()], or [wsc_play_by_plays()]
#' @returns data.frame with one row per event (play) and added columns: `goalieHeight`, `goalieWeight`, `goalieHandCode`, and `goalieAge`
#' @export

add_goalie_biometrics <- function(play_by_play) {
  .require_public_pbp_columns(play_by_play, 'gameId', 'add_goalie_biometrics')
  if (!('goalieInNetId' %in% names(play_by_play)) &&
      !('goaliePlayerIdAgainst' %in% names(play_by_play))) {
    stop(
      "add_goalie_biometrics() requires public play-by-play column(s): goalieInNetId or goaliePlayerIdAgainst",
      call. = FALSE
    )
  }
  bios  <- players()
  games <- games()
  goalieId <- if ('goalieInNetId' %in% names(play_by_play)) {
    goalie_in_net <- suppressWarnings(as.integer(play_by_play$goalieInNetId))
    if ('goaliePlayerIdAgainst' %in% names(play_by_play)) {
      goalie_against <- suppressWarnings(as.integer(play_by_play$goaliePlayerIdAgainst))
      dplyr::coalesce(goalie_in_net, goalie_against)
    } else {
      goalie_in_net
    }
  } else {
    suppressWarnings(as.integer(play_by_play$goaliePlayerIdAgainst))
  }
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

#' Add on-ice shift times to a play-by-play
#'
#' `add_shift_times()` adds `SecondsRemainingInShift`,
#' `SecondsElapsedInShift`, and `SecondsElapsedInPeriodSinceLastShift` columns
#' for the on-ice goalies and skaters already present in a public play-by-play.
#' It accepts either a single game play-by-play plus [shift_chart()] data or a
#' season aggregate plus [shift_charts()] data.
#'
#' @param play_by_play data.frame of play-by-play(s) using the current public schema returned by [gc_play_by_play()], [gc_play_by_plays()], [wsc_play_by_play()], or [wsc_play_by_plays()]
#' @param shift_chart data.frame returned by [shift_chart()] or [shift_charts()]
#' @returns data.frame with one row per event (play) and added or updated scalar on-ice shift timing columns
#' @examples
#' \donttest{
#'   pbp <- gc_play_by_play(game = 2023030417)
#'   sc  <- shift_chart(game = 2023030417)
#'   pbp <- add_shift_times(pbp, sc)
#' }
#' @export
add_shift_times <- function(play_by_play, shift_chart) {
  slot_count <- .on_ice_skater_slots(play_by_play = play_by_play)
  required_skater_cols <- unique(c(
    grep('^(?:home|away)Skater[0-9]+PlayerId$', names(play_by_play), value = TRUE),
    paste0('homeSkater', seq_len(slot_count), 'PlayerId'),
    paste0('awaySkater', seq_len(slot_count), 'PlayerId')
  ))
  .require_public_pbp_columns(
    play_by_play,
    c(
      'gameId',
      'periodNumber',
      'secondsElapsedInPeriod',
      'isHome',
      'homeGoaliePlayerId',
      'awayGoaliePlayerId',
      required_skater_cols
    ),
    'add_shift_times'
  )
  .require_shift_chart_columns(
    shift_chart,
    c(
      'gameId',
      'period',
      'playerId',
      'startSecondsElapsedInPeriod',
      'endSecondsElapsedInPeriod'
    ),
    'add_shift_times'
  )
  timing_cols <- c(
    .on_ice_timing_scalar_column_names(
      'SecondsRemainingInShift',
      play_by_play = play_by_play
    ),
    .on_ice_timing_scalar_column_names(
      'SecondsElapsedInShift',
      play_by_play = play_by_play
    ),
    .on_ice_timing_scalar_column_names(
      'SecondsElapsedInPeriodSinceLastShift',
      play_by_play = play_by_play
    )
  )
  relocate_timing_cols <- function(play_by_play) {
    timing_present <- intersect(timing_cols, names(play_by_play))
    id_present <- intersect(
      .on_ice_id_scalar_column_names(play_by_play = play_by_play),
      names(play_by_play)
    )
    if (!length(timing_present) || !length(id_present)) {
      return(play_by_play)
    }
    non_timing <- setdiff(names(play_by_play), timing_present)
    insert_after <- max(match(id_present, non_timing, nomatch = 0L))
    if (insert_after <= 0L) {
      return(play_by_play)
    }
    tail_cols <- if (insert_after < length(non_timing)) {
      non_timing[(insert_after + 1L):length(non_timing)]
    } else {
      character()
    }
    play_by_play[, c(
      non_timing[seq_len(insert_after)],
      timing_present,
      tail_cols
    ), drop = FALSE]
  }
  for (nm in timing_cols) {
    if (!(nm %in% names(play_by_play))) {
      play_by_play[[nm]] <- rep(NA_real_, nrow(play_by_play))
    }
  }
  play_by_play <- relocate_timing_cols(play_by_play)
  if (!nrow(play_by_play) || !nrow(shift_chart)) {
    return(play_by_play)
  }
  timing <- tryCatch(
    .compute_on_ice_shift_timing_matrices(play_by_play, shift_chart),
    error = function(e) NULL
  )
  if (is.null(timing)) {
    return(play_by_play)
  }
  play_by_play <- .assign_on_ice_shift_metric(
    play_by_play,
    home_matrix = timing$homeRemaining,
    away_matrix = timing$awayRemaining,
    metric_suffix = 'SecondsRemainingInShift'
  )
  play_by_play <- .assign_on_ice_shift_metric(
    play_by_play,
    home_matrix = timing$homeElapsed,
    away_matrix = timing$awayElapsed,
    metric_suffix = 'SecondsElapsedInShift'
  )
  play_by_play <- .assign_on_ice_shift_metric(
    play_by_play,
    home_matrix = timing$homeSinceLast,
    away_matrix = timing$awaySinceLast,
    metric_suffix = 'SecondsElapsedInPeriodSinceLastShift'
  )
  relocate_timing_cols(play_by_play)
}

# Internal helpers --------------------------------------------------------

#' Strip the game ID into the season ID, game type ID, and game number for all the events (plays) in a play-by-play
#' 
#' `.strip_game_id()` strips the game ID into season ID, game type ID, and game number for all the events (plays) in a play-by-play.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] and/or [wsc_play_by_play()] for reference
#' @returns data.frame with one row per event (play) and added columns: `seasonId`, `gameTypeId`, and `gameNumber`
#' @keywords internal

.strip_game_id <- function(play_by_play) {
  game                    <- unique(play_by_play$gameId)
  play_by_play$seasonId   <- game %/% 1e6 * 1e4 + game %/% 1e6 + 1
  play_by_play$gameTypeId <- game %/% 1e4 %% 1e2
  play_by_play$gameNumber <- game %% 1e4
  front                   <- c('gameId', 'eventId', 'seasonId', 'gameTypeId', 'gameNumber', 'sortOrder')
  play_by_play[, c(front, setdiff(names(play_by_play), front))]
}

#' Normalize raw/internal play-by-play names to the public schema
#'
#' `.normalize_public_pbp_names()` renames the raw GameCenter/World Showcase
#' column names used during ingest into the current public play-by-play schema.
#' This helper is for the package's own ingest pipeline only and is not a
#' legacy-input compatibility layer for downstream callers.
#'
#' @param play_by_play data.frame play-by-play object
#' @returns data.frame with current public column names where available
#' @keywords internal
.normalize_public_pbp_names <- function(play_by_play) {
  if (!is.data.frame(play_by_play) || !ncol(play_by_play)) {
    return(play_by_play)
  }
  rename_to_public <- c(
    period = 'periodNumber',
    typeCode = 'eventTypeCode',
    typeDescKey = 'eventTypeDescKey',
    homeSOG = 'homeShots',
    awaySOG = 'awayShots',
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
  play_by_play
}

#' Identify Return-to-Play round-robin shootout games
#'
#' `.covid_round_robin_shootout_game_ids()` returns the 2019-20 round-robin
#' seeding games that used regular-season overtime/shootout rules despite
#' carrying playoff game IDs.
#'
#' @returns integer vector of game IDs
#' @keywords internal
.covid_round_robin_shootout_game_ids <- function() {
  c(2019030002L, 2019030016L)
}

#' Identify shootout-eligible games for public play-by-play cleanup
#'
#' `.public_pbp_is_shootout_eligible()` returns `TRUE` for games whose overtime
#' rules follow the regular-season shootout path.
#'
#' @param game_id integer game IDs
#' @param game_type_id integer game type IDs
#' @returns logical vector
#' @keywords internal
.public_pbp_is_shootout_eligible <- function(game_id, game_type_id) {
  (!is.na(game_type_id) & game_type_id == 2L) |
    (!is.na(game_id) & game_id %in% .covid_round_robin_shootout_game_ids())
}

#' Derive the legal period length in seconds
#'
#' `.public_pbp_legal_period_seconds()` returns the nominal legal length for each
#' play-by-play row's period under the relevant game context.
#'
#' @param game_id integer game IDs
#' @param game_type_id integer game type IDs
#' @param period integer period numbers
#' @returns integer vector of legal period lengths in seconds
#' @keywords internal
.public_pbp_legal_period_seconds <- function(game_id, game_type_id, period) {
  shootout_eligible <- .public_pbp_is_shootout_eligible(game_id, game_type_id)
  out <- ifelse(
    is.na(period),
    NA_integer_,
    ifelse(
      period <= 3L,
      1200L,
      ifelse(
        shootout_eligible & period == 4L,
        300L,
        ifelse(shootout_eligible & period >= 5L, 0L, 1200L)
      )
    )
  )
  as.integer(out)
}

#' Format elapsed seconds as an `MM:SS` clock
#'
#' `.format_elapsed_clock()` converts elapsed-in-period seconds back into
#' zero-padded `MM:SS` strings.
#'
#' @param seconds integer/numeric vector of elapsed seconds
#' @returns character vector
#' @keywords internal
.format_elapsed_clock <- function(seconds) {
  seconds <- suppressWarnings(as.integer(seconds))
  out <- rep(NA_character_, length(seconds))
  ok <- !is.na(seconds) & seconds >= 0L
  if (any(ok)) {
    mins <- seconds[ok] %/% 60L
    secs <- seconds[ok] %% 60L
    out[ok] <- sprintf('%02d:%02d', mins, secs)
  }
  out
}

#' Strip the timestamp and period number into the time elapsed in the period and game for all the events (plays) in a play-by-play
#' 
#' `.strip_time_period()` strips the timestamp and period number into the time elapsed in the period and game for all the events (plays) in a play-by-play.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added columns `secondsElapsedInPeriod` and `secondsElapsedInGame`
#' @keywords internal

.strip_time_period <- function(play_by_play) {
  isPlayoffs <- play_by_play$gameTypeId == 3
  time_in_period <- as.character(play_by_play$timeInPeriod)
  valid_format <- !is.na(time_in_period) &
    grepl('^[0-9]{1,2}:[0-9]{2}$', time_in_period)
  elp <- rep(NA_integer_, length(time_in_period))
  if (any(valid_format)) {
    tp <- strsplit(time_in_period[valid_format], ':', fixed = TRUE)
    mins <- suppressWarnings(as.integer(vapply(tp, `[`, '', 1L)))
    secs <- suppressWarnings(as.integer(vapply(tp, `[`, '', 2L)))
    valid_clock <- !is.na(mins) & !is.na(secs) & secs >= 0L & secs <= 59L
    parsed <- rep(NA_integer_, length(tp))
    parsed[valid_clock] <- 60L * mins[valid_clock] + secs[valid_clock]
    legal_max <- .public_pbp_legal_period_seconds(
      game_id = play_by_play$gameId[valid_format],
      game_type_id = play_by_play$gameTypeId[valid_format],
      period = play_by_play$periodNumber[valid_format]
    )
    parsed[!is.na(parsed) & !is.na(legal_max) & parsed > legal_max] <- NA_integer_
    elp[valid_format] <- parsed
  }
  play_by_play$secondsElapsedInPeriod <- elp
  base <- ifelse(
    play_by_play$periodNumber <= 3L,
    (play_by_play$periodNumber - 1L) * 1200L,
    ifelse(
      isPlayoffs,
      3600L + (play_by_play$periodNumber - 4L) * 1200L,
      3600L + (play_by_play$periodNumber - 4L) * 300L
    )
  )
  play_by_play$secondsElapsedInGame   <- base + elp
  insert <- c('periodNumber', 'timeInPeriod', 'secondsElapsedInPeriod', 'secondsElapsedInGame')
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('sortOrder', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}

#' Repair public play-by-play clock/order defects in boundary-row feeds
#'
#' `.repair_public_pbp_sequence()` removes rows with impossible clocks and
#' reorders explicit-boundary feeds into a more coherent public sequence. The
#' repair is intentionally scoped to the modern boundary-row era, where the
#' audited issues are dominated by stale sort-order markers, early `period-end`
#' rows, and opening faceoffs that arrive after live-play rows.
#'
#' @inheritParams .strip_game_id
#' @returns data.frame with repaired clocks and ordering where feasible
#' @keywords internal
.repair_public_pbp_sequence <- function(play_by_play) {
  n <- nrow(play_by_play)
  if (
    !n ||
      !all(c(
        'gameId', 'seasonId', 'gameTypeId', 'periodNumber', 'sortOrder',
        'timeInPeriod', 'secondsElapsedInPeriod', 'eventTypeDescKey'
      ) %in% names(play_by_play))
  ) {
    return(play_by_play)
  }

  type_desc_key <- as.character(play_by_play$eventTypeDescKey)
  has_boundary_rows <- any(
    !is.na(type_desc_key) &
      type_desc_key %in% c('period-start', 'period-end', 'game-end', 'shootout-complete')
  )
  if (!has_boundary_rows || all(play_by_play$seasonId < 20092010L, na.rm = TRUE)) {
    return(play_by_play)
  }

  has_clock_string <- !is.na(play_by_play$timeInPeriod) & nzchar(play_by_play$timeInPeriod)
  valid_clock <- !is.na(play_by_play$secondsElapsedInPeriod)
  drop_idx <- has_clock_string & !valid_clock
  if (any(drop_idx)) {
    play_by_play <- play_by_play[!drop_idx, , drop = FALSE]
  }
  if (!nrow(play_by_play)) {
    return(play_by_play)
  }

  row_id <- seq_len(nrow(play_by_play))
  original_sort <- suppressWarnings(as.integer(play_by_play$sortOrder))
  original_sort[is.na(original_sort)] <- seq_len(nrow(play_by_play))[is.na(original_sort)]
  new_sort <- original_sort
  new_seconds <- suppressWarnings(as.integer(play_by_play$secondsElapsedInPeriod))

  for (g in unique(play_by_play$gameId)) {
    idx_game <- which(play_by_play$gameId == g)
    idx_game <- idx_game[order(original_sort[idx_game], row_id[idx_game], na.last = TRUE)]
    if (!length(idx_game)) {
      next
    }

    periods <- sort(unique(play_by_play$periodNumber[idx_game]))
    periods <- periods[!is.na(periods)]
    idx_game_new <- integer()

    for (p in periods) {
      idx_period <- idx_game[play_by_play$periodNumber[idx_game] == p]
      if (!length(idx_period)) {
        next
      }

      period_types <- as.character(play_by_play$eventTypeDescKey[idx_period])
      period_secs <- new_seconds[idx_period]
      period_sort <- original_sort[idx_period]
      period_game_type <- suppressWarnings(as.integer(play_by_play$gameTypeId[idx_period][1L]))
      legal_max <- .public_pbp_legal_period_seconds(g, period_game_type, p)[1L]

      is_period_start <- !is.na(period_types) & period_types == 'period-start'
      is_period_end <- !is.na(period_types) & period_types == 'period-end'
      is_game_end <- !is.na(period_types) & period_types == 'game-end'
      is_shootout_complete <- !is.na(period_types) & period_types == 'shootout-complete'
      faceoff_pos <- which(!is.na(period_types) & period_types == 'faceoff')
      opening_faceoff_pos <- if (length(faceoff_pos)) faceoff_pos[1L] else integer()

      if (length(opening_faceoff_pos)) {
        pre_faceoff_pos <- seq_len(opening_faceoff_pos - 1L)
        pre_faceoff_pos <- pre_faceoff_pos[!is_period_start[pre_faceoff_pos]]
        if (length(pre_faceoff_pos)) {
          earliest_pre_sec <- suppressWarnings(min(period_secs[pre_faceoff_pos], na.rm = TRUE))
          if (is.finite(earliest_pre_sec)) {
            target_sec <- if (is.na(period_secs[opening_faceoff_pos])) {
              as.integer(earliest_pre_sec)
            } else {
              min(as.integer(period_secs[opening_faceoff_pos]), as.integer(earliest_pre_sec))
            }
            period_secs[opening_faceoff_pos] <- as.integer(target_sec)
          }
        }
      }

      non_terminal_pos <- which(!(is_period_end | is_game_end | is_shootout_complete))
      observed_period_max <- suppressWarnings(max(period_secs[non_terminal_pos], na.rm = TRUE))
      if (!is.finite(observed_period_max)) {
        observed_period_max <- NA_integer_
      } else {
        observed_period_max <- as.integer(observed_period_max)
      }
      has_goal <- any(!is.na(period_types) & period_types == 'goal')
      has_later_period <- any(play_by_play$periodNumber[idx_game] > p, na.rm = TRUE)
      use_legal_terminal <- !is.na(legal_max) && (
        p <= 3L ||
          (.public_pbp_is_shootout_eligible(g, period_game_type) &&
             p == 4L &&
             !has_goal &&
             has_later_period)
      )
      terminal_sec <- suppressWarnings(max(
        c(
          period_secs[is_period_end],
          observed_period_max,
          if (use_legal_terminal) legal_max else NA_integer_
        ),
        na.rm = TRUE
      ))
      if (!is.finite(terminal_sec)) {
        terminal_sec <- if (!is.na(legal_max)) legal_max else 0L
      }
      terminal_sec <- as.integer(max(0L, terminal_sec))
      if (any(is_period_start)) {
        period_secs[is_period_start] <- 0L
      }
      if (any(is_period_end)) {
        period_secs[is_period_end] <- terminal_sec
      }
      if (any(is_game_end)) {
        period_secs[is_game_end] <- terminal_sec
      }
      if (any(is_shootout_complete) && is.na(legal_max)) {
        period_secs[is_shootout_complete] <- terminal_sec
      }

      regular_pos <- which(!(is_period_start | is_period_end | is_game_end | is_shootout_complete))
      if (length(opening_faceoff_pos)) {
        regular_pos <- setdiff(regular_pos, opening_faceoff_pos)
      }
      regular_pos <- regular_pos[order(
        period_secs[regular_pos],
        period_sort[regular_pos],
        row_id[idx_period[regular_pos]],
        na.last = TRUE
      )]

      idx_period_new <- c(
        idx_period[which(is_period_start)],
        if (length(opening_faceoff_pos)) idx_period[opening_faceoff_pos] else integer(),
        idx_period[regular_pos],
        idx_period[which(is_shootout_complete)],
        idx_period[which(is_period_end)],
        idx_period[which(is_game_end)]
      )
      idx_game_new <- c(idx_game_new, idx_period_new)
      new_seconds[idx_period] <- period_secs
    }

    if (length(idx_game_new) != length(idx_game)) {
      missing_idx <- setdiff(idx_game, idx_game_new)
      idx_game_new <- c(idx_game_new, missing_idx)
    }
    idx_game_new <- idx_game_new[!duplicated(idx_game_new)]
    new_sort[idx_game_new] <- sort(original_sort[idx_game], na.last = TRUE)
  }

  play_by_play$sortOrder <- new_sort
  play_by_play$secondsElapsedInPeriod <- new_seconds
  play_by_play$timeInPeriod <- .format_elapsed_clock(play_by_play$secondsElapsedInPeriod)
  play_by_play <- .strip_time_period(play_by_play)
  play_by_play[order(play_by_play$sortOrder, row_id, na.last = TRUE), , drop = FALSE]
}

#' Remove illogically ordered boundary events from a play-by-play
#'
#' `.drop_illogical_ordered_events()` removes stray boundary rows that can
#' appear between a period's `period-end` and the following period's
#' `period-start`. In practice, these are most often duplicated `0:00`
#' `faceoff`/`stoppage` rows that are still tagged to the previous period even
#' though the actual opening sequence for the next period follows immediately
#' after.
#'
#' @inheritParams .strip_game_id
#' @returns data.frame with illogically ordered boundary events removed
#' @keywords internal

.drop_illogical_ordered_events <- function(play_by_play) {
  n <- nrow(play_by_play)
  if (n < 3L) {
    return(play_by_play)
  }
  keep <- rep(TRUE, n)
  game_id <- as.integer(play_by_play$gameId)
  for (g in unique(game_id)) {
    idx <- which(game_id == g)
    idx <- idx[order(play_by_play$sortOrder[idx], na.last = TRUE)]
    if (length(idx) < 3L) {
      next
    }
    for (k in 2:(length(idx) - 1L)) {
      prev_i <- idx[k - 1L]
      cur_i <- idx[k]
      next_i <- idx[k + 1L]
      if (
        identical(play_by_play$eventTypeDescKey[prev_i], 'period-end') &&
          identical(play_by_play$eventTypeDescKey[next_i], 'period-start') &&
          play_by_play$eventTypeDescKey[cur_i] %in% c('faceoff', 'stoppage') &&
          !is.na(play_by_play$secondsElapsedInPeriod[cur_i]) &&
          play_by_play$secondsElapsedInPeriod[cur_i] == 0L &&
          !is.na(play_by_play$secondsElapsedInPeriod[next_i]) &&
          play_by_play$secondsElapsedInPeriod[next_i] == 0L &&
          !is.na(play_by_play$periodNumber[prev_i]) &&
          !is.na(play_by_play$periodNumber[cur_i]) &&
          !is.na(play_by_play$periodNumber[next_i]) &&
          play_by_play$periodNumber[cur_i] == play_by_play$periodNumber[prev_i] &&
          play_by_play$periodNumber[next_i] == play_by_play$periodNumber[prev_i] + 1L
      ) {
        keep[cur_i] <- FALSE
      }
    }
  }
  play_by_play <- play_by_play[keep, , drop = FALSE]
  n <- nrow(play_by_play)
  if (
    n < 3L ||
      !all(c('gameId', 'periodNumber', 'sortOrder', 'eventTypeDescKey') %in% names(play_by_play))
  ) {
    return(play_by_play)
  }

  row_id <- seq_len(n)
  game_id <- as.integer(play_by_play$gameId)
  period <- as.integer(play_by_play$periodNumber)
  type_desc_key <- as.character(play_by_play$eventTypeDescKey)
  sort_order <- as.integer(play_by_play$sortOrder)

  for (g in unique(game_id)) {
    idx_game <- which(game_id == g)
    idx_sorted <- idx_game[order(sort_order[idx_game], row_id[idx_game], na.last = TRUE)]
    if (length(idx_sorted) < 3L) {
      next
    }

    periods <- unique(period[idx_sorted])
    periods <- periods[!is.na(periods)]
    for (p in periods) {
      idx_period <- idx_sorted[period[idx_sorted] == p]
      if (length(idx_period) < 3L) {
        next
      }
      period_types <- type_desc_key[idx_period]
      period_start_pos <- which(period_types == 'period-start')
      faceoff_pos <- which(period_types == 'faceoff')
      if (!length(period_start_pos) || !length(faceoff_pos)) {
        next
      }
      period_start_pos <- period_start_pos[1L]
      faceoff_pos <- faceoff_pos[faceoff_pos > period_start_pos]
      if (!length(faceoff_pos)) {
        next
      }
      faceoff_pos <- faceoff_pos[1L]
      if (faceoff_pos == period_start_pos + 1L) {
        next
      }
      intervening_pos <- seq.int(period_start_pos + 1L, faceoff_pos - 1L)
      intervening_types <- period_types[intervening_pos]
      if (!any(!is.na(intervening_types))) {
        next
      }
      idx_period <- c(
        idx_period[seq_len(period_start_pos)],
        idx_period[faceoff_pos],
        idx_period[intervening_pos],
        if (faceoff_pos < length(idx_period)) {
          idx_period[(faceoff_pos + 1L):length(idx_period)]
        } else {
          integer(0)
        }
      )
      idx_sorted[period[idx_sorted] == p] <- idx_period
    }

    sort_order[idx_sorted] <- sort(sort_order[idx_game], na.last = TRUE)
  }

  play_by_play$sortOrder <- sort_order
  play_by_play[order(sort_order, row_id, na.last = TRUE), , drop = FALSE]
}

#' Ensure a local native symbol is loaded
#'
#' `.ensure_local_native_symbol()` tries to load the package shared object from
#' the local `src/` directory when a native symbol is not yet registered.
#'
#' @param symbol native symbol name
#' @returns logical scalar indicating whether the symbol is available
#' @keywords internal
.ensure_local_native_symbol <- function(symbol) {
  if (is.loaded(symbol)) {
    return(TRUE)
  }
  dlls <- getLoadedDLLs()
  if ('nhlscraper' %in% names(dlls)) {
    return(is.loaded(symbol))
  }
  dll_path <- file.path(getwd(), 'src', 'nhlscraper.so')
  if (!file.exists(dll_path)) {
    return(FALSE)
  }
  tryCatch(
    {
      dyn.load(dll_path)
      is.loaded(symbol)
    },
    error = function(e) FALSE
  )
}

#' Validate required public play-by-play columns
#'
#' `.require_public_pbp_columns()` errors when a public helper is called with a
#' play-by-play missing required public schema columns.
#'
#' @param play_by_play data.frame play-by-play object
#' @param cols character vector of required columns
#' @param fn_name calling function name used in the error message
#' @returns `NULL`, invisibly, or an error if required columns are missing
#' @keywords internal
.require_public_pbp_columns <- function(play_by_play, cols, fn_name) {
  missing_cols <- setdiff(cols, names(play_by_play))
  if (length(missing_cols)) {
    stop(
      sprintf(
        "%s() requires public play-by-play column(s): %s",
        fn_name,
        paste(missing_cols, collapse = ", ")
      ),
      call. = FALSE
    )
  }
}

#' Validate required shift-chart columns
#'
#' `.require_shift_chart_columns()` errors when a helper is called with a shift
#' chart missing required public schema columns.
#'
#' @param shift_chart data.frame shift chart object
#' @param cols character vector of required columns
#' @param fn_name calling function name used in the error message
#' @returns `NULL`, invisibly, or an error if required columns are missing
#' @keywords internal
.require_shift_chart_columns <- function(shift_chart, cols, fn_name) {
  missing_cols <- setdiff(cols, names(shift_chart))
  if (length(missing_cols)) {
    stop(
      sprintf(
        "%s() requires shift chart column(s): %s",
        fn_name,
        paste(missing_cols, collapse = ", ")
      ),
      call. = FALSE
    )
  }
}

#' Build a shot-event mask
#'
#' `.shot_event_mask()` flags play-by-play rows matching selected event types.
#'
#' @param play_by_play data.frame play-by-play object
#' @param types character vector of event type keys to keep
#' @returns logical vector
#' @keywords internal
.shot_event_mask <- function(play_by_play, types) {
  n <- nrow(play_by_play)
  if (!n) return(logical(0))
  eventTypeDescKey <- if ('eventTypeDescKey' %in% names(play_by_play)) {
    as.character(play_by_play$eventTypeDescKey)
  } else {
    rep(NA_character_, n)
  }
  !is.na(eventTypeDescKey) & eventTypeDescKey %in% types
}

#' Compute shot context summaries
#'
#' `.compute_shot_context()` derives rush and rebound flags plus running goal,
#' shot, Fenwick, and Corsi counts, using native code when available.
#'
#' @param play_by_play data.frame play-by-play object
#' @returns named list of logical and integer shot-context vectors
#' @keywords internal
.compute_shot_context <- function(play_by_play) {
  n <- nrow(play_by_play)
  if (!n) {
    return(list(
      isRush = logical(0),
      isRebound = logical(0),
      createdRebound = logical(0),
      homeGoals = integer(0),
      awayGoals = integer(0),
      homeShots = integer(0),
      awayShots = integer(0),
      homeFenwick = integer(0),
      awayFenwick = integer(0),
      homeCorsi = integer(0),
      awayCorsi = integer(0)
    ))
  }

  type_desc_key <- if ('eventTypeDescKey' %in% names(play_by_play)) {
    as.character(play_by_play$eventTypeDescKey)
  } else {
    rep(NA_character_, n)
  }
  zone_code <- if ('zoneCode' %in% names(play_by_play)) {
    as.character(play_by_play$zoneCode)
  } else {
    rep(NA_character_, n)
  }
  game_id <- if ('gameId' %in% names(play_by_play)) {
    as.integer(play_by_play$gameId)
  } else {
    seq_len(n)
  }
  sort_order <- if ('sortOrder' %in% names(play_by_play)) {
    as.integer(play_by_play$sortOrder)
  } else {
    seq_len(n)
  }
  seconds_elapsed <- if ('secondsElapsedInGame' %in% names(play_by_play)) {
    as.integer(play_by_play$secondsElapsedInGame)
  } else {
    rep(NA_integer_, n)
  }
  is_home <- if ('isHome' %in% names(play_by_play)) {
    ifelse(
      play_by_play$isHome %in% TRUE,
      1L,
      ifelse(play_by_play$isHome %in% FALSE, 0L, NA_integer_)
    )
  } else {
    rep(NA_integer_, n)
  }
  valid_type <- !is.na(type_desc_key)
  is_attempt <- valid_type & type_desc_key %in% c(
    'goal', 'shot-on-goal', 'missed-shot', 'blocked-shot'
  )
  is_source <- valid_type & type_desc_key %in% c(
    'shot-on-goal', 'missed-shot', 'blocked-shot'
  )
  is_goal <- valid_type & type_desc_key == 'goal'
  is_sog <- valid_type & type_desc_key %in% c('goal', 'shot-on-goal')
  is_fenwick <- valid_type & type_desc_key %in% c(
    'goal', 'shot-on-goal', 'missed-shot'
  )
  is_corsi <- valid_type & type_desc_key %in% c(
    'goal', 'shot-on-goal', 'missed-shot', 'blocked-shot'
  )
  is_stop <- valid_type & type_desc_key %in% c(
    'stoppage', 'faceoff', 'period-start', 'period-end', 'game-end'
  )
  is_nz_dz <- !is.na(zone_code) & zone_code %in% c('N', 'D')
  situation_code <- if ('situationCode' %in% names(play_by_play)) {
    as.character(play_by_play$situationCode)
  } else {
    rep(NA_character_, n)
  }
  is_ps_so <- !is.na(situation_code) & situation_code %in% c('0101', '1010')
  order_time <- order(game_id, seconds_elapsed, sort_order, seq_len(n), na.last = TRUE)
  order_sort <- order(game_id, sort_order, seq_len(n), na.last = TRUE)

  compute_in_r <- function() {
    event_owner_team_id <- if ('eventOwnerTeamId' %in% names(play_by_play)) {
      as.integer(play_by_play$eventOwnerTeamId)
    } else {
      rep(NA_integer_, n)
    }
    is_rush <- rep(NA, n)
    is_rush[is_attempt] <- FALSE
    is_rebound <- rep(NA, n)
    is_rebound[is_attempt] <- FALSE
    created_rebound <- rep(NA, n)
    created_rebound[is_attempt] <- FALSE

    for (g in unique(game_id)) {
      idx_time <- order_time[game_id[order_time] == g]
      last_nz_dz_time <- NA_integer_
      last_time <- integer(0)
      last_idx <- integer(0)
      names(last_time) <- character(0)
      names(last_idx) <- character(0)
      for (i in idx_time) {
        if (is_stop[i]) {
          last_nz_dz_time <- NA_integer_
          last_time <- integer(0)
          last_idx <- integer(0)
          names(last_time) <- character(0)
          names(last_idx) <- character(0)
          next
        }
        t <- seconds_elapsed[i]
        if (!is.na(t)) {
          if (is_attempt[i] && !is.na(last_nz_dz_time) && t - last_nz_dz_time >= 0L &&
              t - last_nz_dz_time <= 4L) {
            is_rush[i] <- TRUE
          }
          tid <- as.character(event_owner_team_id[i])
          if (is_attempt[i] && length(last_time) && tid %in% names(last_time)) {
            dt <- t - last_time[[tid]]
            if (!is.na(dt) && dt >= 0L && dt <= 3L) {
              is_rebound[i] <- TRUE
              created_rebound[last_idx[[tid]]] <- TRUE
            }
          }
          if (is_nz_dz[i]) {
            last_nz_dz_time <- t
          }
          if (is_source[i] && !is.na(event_owner_team_id[i])) {
            last_time[tid] <- t
            last_idx[tid] <- i
          }
        }
      }
    }

    is_rush[is_attempt & is_ps_so] <- FALSE
    is_rebound[is_attempt & is_ps_so] <- FALSE
    created_rebound[is_attempt & is_ps_so] <- FALSE

    home_goals <- integer(n)
    away_goals <- integer(n)
    home_sog <- integer(n)
    away_sog <- integer(n)
    home_fenwick <- integer(n)
    away_fenwick <- integer(n)
    home_corsi <- integer(n)
    away_corsi <- integer(n)

    for (g in unique(game_id)) {
      idx_sort <- order_sort[game_id[order_sort] == g]
      hG <- 0L
      aG <- 0L
      hS <- 0L
      aS <- 0L
      hF <- 0L
      aF <- 0L
      hC <- 0L
      aC <- 0L
      for (i in idx_sort) {
        home_goals[i] <- hG
        away_goals[i] <- aG
        home_sog[i] <- hS
        away_sog[i] <- aS
        home_fenwick[i] <- hF
        away_fenwick[i] <- aF
        home_corsi[i] <- hC
        away_corsi[i] <- aC
        if (!is.na(is_home[i]) && is_home[i] == 1L) {
          hG <- hG + as.integer(is_goal[i])
          hS <- hS + as.integer(is_sog[i])
          hF <- hF + as.integer(is_fenwick[i])
          hC <- hC + as.integer(is_corsi[i])
        } else if (!is.na(is_home[i]) && is_home[i] == 0L) {
          aG <- aG + as.integer(is_goal[i])
          aS <- aS + as.integer(is_sog[i])
          aF <- aF + as.integer(is_fenwick[i])
          aC <- aC + as.integer(is_corsi[i])
        }
      }
    }

    list(
      isRush = is_rush,
      isRebound = is_rebound,
      createdRebound = created_rebound,
      homeGoals = home_goals,
      awayGoals = away_goals,
      homeShots = home_sog,
      awayShots = away_sog,
      homeFenwick = home_fenwick,
      awayFenwick = away_fenwick,
      homeCorsi = home_corsi,
      awayCorsi = away_corsi
    )
  }

  if (!.ensure_local_native_symbol('nhlscraper_pbp_shot_context')) {
    return(compute_in_r())
  }

  tryCatch(
    .Call('nhlscraper_pbp_shot_context', list(
      as.integer(order_time),
      as.integer(order_sort),
      as.integer(game_id),
      as.integer(seconds_elapsed),
      if ('eventOwnerTeamId' %in% names(play_by_play)) as.integer(play_by_play$eventOwnerTeamId) else rep(NA_integer_, n),
      as.integer(is_home),
      as.logical(is_attempt),
      as.logical(is_source),
      as.logical(is_goal),
      as.logical(is_sog),
      as.logical(is_fenwick),
      as.logical(is_corsi),
      as.logical(is_stop),
      as.logical(is_nz_dz),
      as.logical(is_ps_so)
    )),
    error = function(e) compute_in_r()
  )
}

#' Attach shot context columns to play-by-play
#'
#' `.apply_shot_context()` appends rush, rebound, and running score/attempt
#' context columns to a play-by-play.
#'
#' @param play_by_play data.frame play-by-play object
#' @returns data.frame with shot context columns added
#' @keywords internal
.apply_shot_context <- function(play_by_play) {
  ctx <- .compute_shot_context(play_by_play)
  if (is.null(ctx$homeShots) && !is.null(ctx$homeSOG)) {
    ctx$homeShots <- ctx$homeSOG
  }
  if (is.null(ctx$awayShots) && !is.null(ctx$awaySOG)) {
    ctx$awayShots <- ctx$awaySOG
  }
  is_home <- if ('isHome' %in% names(play_by_play)) {
    ifelse(
      play_by_play$isHome %in% TRUE,
      1L,
      ifelse(play_by_play$isHome %in% FALSE, 0L, NA_integer_)
    )
  } else {
    rep(NA_integer_, nrow(play_by_play))
  }

  play_by_play$isRush <- ctx$isRush
  play_by_play$isRebound <- ctx$isRebound
  play_by_play$createdRebound <- ctx$createdRebound
  play_by_play$homeGoals <- ctx$homeGoals
  play_by_play$awayGoals <- ctx$awayGoals
  play_by_play$homeShots <- ctx$homeShots
  play_by_play$awayShots <- ctx$awayShots
  play_by_play$homeFenwick <- ctx$homeFenwick
  play_by_play$awayFenwick <- ctx$awayFenwick
  play_by_play$homeCorsi <- ctx$homeCorsi
  play_by_play$awayCorsi <- ctx$awayCorsi
  play_by_play$goalsFor <- ifelse(
    is_home == 1L,
    play_by_play$homeGoals,
    ifelse(is_home == 0L, play_by_play$awayGoals, NA_integer_)
  )
  play_by_play$goalsAgainst <- ifelse(
    is_home == 1L,
    play_by_play$awayGoals,
    ifelse(is_home == 0L, play_by_play$homeGoals, NA_integer_)
  )
  play_by_play$shotsFor <- ifelse(
    is_home == 1L,
    play_by_play$homeShots,
    ifelse(is_home == 0L, play_by_play$awayShots, NA_integer_)
  )
  play_by_play$shotsAgainst <- ifelse(
    is_home == 1L,
    play_by_play$awayShots,
    ifelse(is_home == 0L, play_by_play$homeShots, NA_integer_)
  )
  play_by_play$fenwickFor <- ifelse(
    is_home == 1L,
    play_by_play$homeFenwick,
    ifelse(is_home == 0L, play_by_play$awayFenwick, NA_integer_)
  )
  play_by_play$fenwickAgainst <- ifelse(
    is_home == 1L,
    play_by_play$awayFenwick,
    ifelse(is_home == 0L, play_by_play$homeFenwick, NA_integer_)
  )
  play_by_play$corsiFor <- ifelse(
    is_home == 1L,
    play_by_play$homeCorsi,
    ifelse(is_home == 0L, play_by_play$awayCorsi, NA_integer_)
  )
  play_by_play$corsiAgainst <- ifelse(
    is_home == 1L,
    play_by_play$awayCorsi,
    ifelse(is_home == 0L, play_by_play$homeCorsi, NA_integer_)
  )
  play_by_play$goalDifferential <- play_by_play$goalsFor - play_by_play$goalsAgainst
  play_by_play$shotDifferential <- play_by_play$shotsFor - play_by_play$shotsAgainst
  play_by_play$fenwickDifferential <- play_by_play$fenwickFor - play_by_play$fenwickAgainst
  play_by_play$corsiDifferential <- play_by_play$corsiFor - play_by_play$corsiAgainst
  play_by_play
}

#' Normalize situation codes for parsing
#'
#' `.normalize_situation_code_for_parse()` pads 1-4 digit situation codes to
#' four characters for internal parsing without rewriting the source column.
#'
#' @param situation_code vector of raw situation codes
#' @returns character vector of parse-ready situation codes
#' @keywords internal
.normalize_situation_code_for_parse <- function(situation_code) {
  sc_chr <- as.character(situation_code)
  ok <- !is.na(sc_chr) & grepl('^[0-9]{1,4}$', sc_chr)
  out <- rep(NA_character_, length(sc_chr))
  if (any(ok)) {
    out[ok] <- sprintf('%04s', sc_chr[ok])
    out[ok] <- chartr(' ', '0', out[ok])
  }
  out
}

#' Parse situation-code components
#'
#' `.parse_situation_code_components()` converts situation codes into away/home
#' goalie and skater counts without mutating the original source vector.
#'
#' @param situation_code vector of raw situation codes
#' @returns integer matrix with away/home goalie and skater counts
#' @keywords internal
.parse_situation_code_components <- function(situation_code) {
  sc_chr <- .normalize_situation_code_for_parse(situation_code)
  cbind(
    awayGoalieCount = suppressWarnings(as.integer(substr(sc_chr, 1L, 1L))),
    awaySkaterCount = suppressWarnings(as.integer(substr(sc_chr, 2L, 2L))),
    homeSkaterCount = suppressWarnings(as.integer(substr(sc_chr, 3L, 3L))),
    homeGoalieCount = suppressWarnings(as.integer(substr(sc_chr, 4L, 4L)))
  )
}

#' Strip the situation code into goalie and skater counts, man differential, and strength state for all the events (plays) in a play-by-play by perspective
#' 
#' `.strip_situation_code()` strips the situation code into goalie and skater counts for home and away teams, then (from the event owner's perspective) computes man differential and a strength state classification without rewriting the source `situationCode` column.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added columns: `homeIsEmptyNet`, `awayIsEmptyNet`, `homeSkaterCount`, `awaySkaterCount`, `isEmptyNetFor`, `isEmptyNetAgainst`, `skaterCountFor`, `skaterCountAgainst`, `manDifferential`, and `strengthState`
#' @keywords internal
.strip_situation_code <- function(play_by_play) {
  sc_raw <- if ('situationCode' %in% names(play_by_play)) {
    play_by_play$situationCode
  } else {
    rep(NA_character_, nrow(play_by_play))
  }
  sc_parts <- .parse_situation_code_components(sc_raw)
  aG <- sc_parts[, 'awayGoalieCount']
  aS <- sc_parts[, 'awaySkaterCount']
  hS <- sc_parts[, 'homeSkaterCount']
  hG <- sc_parts[, 'homeGoalieCount']
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
#' `.flag_is_home()` flags if the event belongs to the home team or not for all the events (plays) in a play-by-play.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added `isHome` column
#' @keywords internal

.flag_is_home <- function(play_by_play) {
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
  ho  <- fill_down(pbp$homeShots)
  ao  <- fill_down(pbp$awayShots)
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
  insert <- c('eventOwnerTeamId', 'isHome', 'eventTypeCode', 'eventTypeDescKey')
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('secondsElapsedInGame', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}

#' Flag if the shot attempt is a rush attempt or not for all the shots in a play-by-play
#' 
#' `.flag_is_rush()` flags whether a shot attempt is a rush attempt, defined as any shot attempt occurring within 4 seconds of a prior event in the neutral or defensive zone with no stoppage in play in between.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added `isRush` column
#' @keywords internal

.flag_is_rush <- function(play_by_play) {
  play_by_play$isRush <- .compute_shot_context(play_by_play)$isRush
  after               <- match('angle', names(play_by_play))
  insert              <- c('shotType', 'isRush')
  nms                 <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Flag if the shot attempt is a rebound attempt or creates a rebound for all the shots in a play-by-play
#' 
#' `.flag_is_rebound()` flags whether a shot attempt is a rebound attempt (i.e., taken within 3 seconds of a prior blocked, missed, or saved attempt with no stoppage in between), and whether a shot attempt creates a rebound under the same definition.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added columns: `createdRebound` and `isRebound`
#' @keywords internal

.flag_is_rebound <- function(play_by_play) {
  ctx <- .compute_shot_context(play_by_play)
  play_by_play$createdRebound <- ctx$createdRebound
  play_by_play$isRebound      <- ctx$isRebound
  after  <- match('isRush', names(play_by_play))
  insert <- c('isRebound', 'createdRebound')
  nms    <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Normalize the x and y coordinates for all the events (plays) in a play-by-play
#' 
#' `.normalize_coordinates()` normalizes the x and y coordinates for all the events (plays) in a play-by-play such that they all attack towards +x. If `homeTeamDefendingSide` is not available, the home defending side in period 1 is inferred using `zoneCode`, `isHome`, and `xCoord`.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added columns `xCoordNorm` and `yCoordNorm`
#' @keywords internal

.normalize_coordinates <- function(play_by_play) {
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
          play_by_play$periodNumber[idx] == 1L & 
          !is.na(play_by_play$xCoord[idx])
      ]
      o_idx         <- idx[
        play_by_play$isHome[idx] & 
          play_by_play$zoneCode[idx] == 'O' &
          play_by_play$periodNumber[idx] == 1L & 
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
    home_att_pos    <- ifelse(play_by_play$periodNumber[idx] %% 2L == 1L, home_att_pos_p1, !home_att_pos_p1)
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
#' `.calculate_distance()` calculates the Euclidean distance from the attacking net for all the events (plays) in a play-by-play.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added `distance` column
#' @keywords internal

.calculate_distance <- function(play_by_play) {
  net_x                 <- 89
  play_by_play$distance <- sqrt((net_x - play_by_play$xCoordNorm)^2 + (play_by_play$yCoordNorm)^2)
  after                 <- match('yCoordNorm', names(play_by_play))
  insert                <- 'distance'
  nms                   <- names(play_by_play)
  play_by_play[, c(nms[seq_len(after)], insert, setdiff(nms[-seq_len(after)], insert))]
}

#' Calculate the Euclidean angle from the attacking net for all the events (plays) in a play-by-play
#' 
#' `.calculate_angle()` calculates the Euclidean angle from the attacking net for all the events (plays) in a play-by-play.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added `angle` column
#' @keywords internal

.calculate_angle <- function(play_by_play) {
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
#' `.count_goals_shots()` counts the as-of-event goal, shots on goal, Fenwick, and Corsi attempts and differentials for all the events (plays) in a play-by-play by perspective.
#' 
#' @inheritParams .strip_game_id
#' @returns data.frame with one row per event (play) and added columns: `homeGoals`, `awayGoals`, `homeShots`, `awayShots`, `homeFenwick`, `awayFenwick`, `homeCorsi`, `awayCorsi`, `goalsFor`, `goalsAgainst`, `shotsFor`, `shotsAgainst`, `fenwickFor`, `fenwickAgainst`, `corsiFor`, `corsiAgainst`, `goalDifferential`, `shotDifferential`, `fenwickDifferential`, and `corsiDifferential`
#' @keywords internal

.count_goals_shots <- function(play_by_play) {
  play_by_play <- .apply_shot_context(play_by_play)
  insert <- c(
    'homeGoals', 'awayGoals', 'homeShots', 'awayShots', 'homeFenwick', 'awayFenwick', 'homeCorsi', 'awayCorsi',
    'goalsFor', 'goalsAgainst', 'shotsFor', 'shotsAgainst', 'fenwickFor', 'fenwickAgainst', 'corsiFor', 'corsiAgainst',
    'goalDifferential', 'shotDifferential', 'fenwickDifferential', 'corsiDifferential'
  )
  keep   <- setdiff(names(play_by_play), insert)
  after  <- match('createdRebound', keep)
  play_by_play[, c(keep[seq_len(after)], insert, keep[(after + 1L):length(keep)])]
}

#' Extract an integer on-ice column
#'
#' `.on_ice_int_col()` safely extracts an integer column from a data frame and
#' returns `NA` values when the column is absent.
#'
#' @param df data.frame source object
#' @param name column name to extract
#' @returns integer vector
#' @keywords internal
.on_ice_int_col <- function(df, name) {
  if (name %in% names(df)) as.integer(df[[name]]) else rep(NA_integer_, nrow(df))
}

#' Build scalar on-ice timing column names
#'
#' `.on_ice_timing_scalar_column_names()` returns the scalar goalie and skater
#' timing column names for a timing metric suffix.
#'
#' @param metric_suffix scalar timing suffix
#' @param play_by_play optional data.frame whose existing on-ice columns should
#'   be inspected
#' @param slot_count optional integer scalar minimum slot count requested by the
#'   caller
#' @returns character vector of column names
#' @keywords internal
.on_ice_timing_scalar_column_names <- function(
  metric_suffix,
  play_by_play = NULL,
  slot_count = NULL
) {
  skater_slots <- seq_len(.on_ice_skater_slots(
    play_by_play = play_by_play,
    slot_count = slot_count
  ))
  c(
    paste0('homeGoalie', metric_suffix),
    paste0('awayGoalie', metric_suffix),
    paste0('goalie', metric_suffix, 'For'),
    paste0('goalie', metric_suffix, 'Against'),
    as.vector(rbind(
      paste0('homeSkater', skater_slots, metric_suffix),
      paste0('awaySkater', skater_slots, metric_suffix),
      paste0('skater', skater_slots, metric_suffix, 'For'),
      paste0('skater', skater_slots, metric_suffix, 'Against')
    ))
  )
}

#' Sort shift data for timing lookups
#'
#' `.sort_shift_chart_for_timing()` filters incomplete shift rows and sorts the
#' remainder into the order expected by the timing resolvers.
#'
#' @param shift_data data.frame shift chart data
#' @returns filtered and sorted shift data.frame
#' @keywords internal
.sort_shift_chart_for_timing <- function(shift_data) {
  shift_data <- shift_data[
    !is.na(shift_data$gameId) &
      !is.na(shift_data$period) &
      !is.na(shift_data$playerId) &
      !is.na(shift_data$startSecondsElapsedInPeriod) &
      !is.na(shift_data$endSecondsElapsedInPeriod),
    ,
    drop = FALSE
  ]
  if (!nrow(shift_data)) {
    return(shift_data)
  }
  ord <- order(
    as.integer(shift_data$gameId),
    as.integer(shift_data$period),
    as.integer(shift_data$playerId),
    as.integer(shift_data$startSecondsElapsedInPeriod),
    as.integer(shift_data$endSecondsElapsedInPeriod)
  )
  shift_data[ord, , drop = FALSE]
}

#' Compute on-ice shift timings in R
#'
#' `.compute_on_ice_shift_timing_in_r()` is the pure-R fallback for resolving
#' on-ice remaining-shift, elapsed-shift, and time-since-last-shift matrices.
#'
#' @param play_by_play data.frame play-by-play object with on-ice player IDs
#' @param shift_data data.frame shift chart data
#' @returns list containing home and away timing matrices
#' @keywords internal
.compute_on_ice_shift_timing_in_r <- function(play_by_play, shift_data) {
  n <- nrow(play_by_play)
  slot_count <- .on_ice_skater_slots(play_by_play = play_by_play)
  home_request <- cbind(
    as.integer(play_by_play$homeGoaliePlayerId),
    as.matrix(play_by_play[, paste0('homeSkater', seq_len(slot_count), 'PlayerId'), drop = FALSE])
  )
  away_request <- cbind(
    as.integer(play_by_play$awayGoaliePlayerId),
    as.matrix(play_by_play[, paste0('awaySkater', seq_len(slot_count), 'PlayerId'), drop = FALSE])
  )
  storage.mode(home_request) <- 'integer'
  storage.mode(away_request) <- 'integer'

  home_elapsed <- matrix(NA_real_, nrow = n, ncol = slot_count + 1L)
  away_elapsed <- matrix(NA_real_, nrow = n, ncol = slot_count + 1L)
  home_remaining <- matrix(NA_real_, nrow = n, ncol = slot_count + 1L)
  away_remaining <- matrix(NA_real_, nrow = n, ncol = slot_count + 1L)
  home_since <- matrix(NA_real_, nrow = n, ncol = slot_count + 1L)
  away_since <- matrix(NA_real_, nrow = n, ncol = slot_count + 1L)
  if (!nrow(shift_data) || !n) {
    return(list(
      homeRemaining = home_remaining,
      awayRemaining = away_remaining,
      homeElapsed = home_elapsed,
      awayElapsed = away_elapsed,
      homeSinceLast = home_since,
      awaySinceLast = away_since
    ))
  }

  prev_end <- rep(NA_integer_, nrow(shift_data))
  keys <- paste(shift_data$gameId, shift_data$period, shift_data$playerId, sep = ':')
  if (nrow(shift_data) > 1L) {
    for (i in 2:nrow(shift_data)) {
      if (keys[i] == keys[i - 1L]) {
        prev_end[i] <- as.integer(shift_data$endSecondsElapsedInPeriod[i - 1L])
      }
    }
  }
  split_idx <- split(seq_len(nrow(shift_data)), keys)

  lookup_player <- function(game_id, period, seconds_elapsed, player_id) {
    if (
      is.na(game_id) ||
      is.na(period) ||
      is.na(seconds_elapsed) ||
      is.na(player_id)
    ) {
      return(c(NA_real_, NA_real_, NA_real_))
    }
    idx <- split_idx[[paste(game_id, period, player_id, sep = ':')]]
    if (is.null(idx) || !length(idx)) {
      return(c(NA_real_, NA_real_, NA_real_))
    }
    starts <- as.integer(shift_data$startSecondsElapsedInPeriod[idx])
    ends <- as.integer(shift_data$endSecondsElapsedInPeriod[idx])
    pos <- findInterval(as.integer(seconds_elapsed), starts)
    if (pos < 1L || pos > length(idx)) {
      return(c(NA_real_, NA_real_, NA_real_))
    }
    row_idx <- idx[pos]
    if (seconds_elapsed > ends[pos]) {
      return(c(NA_real_, NA_real_, NA_real_))
    }
    remaining <- as.numeric(ends[pos] - seconds_elapsed)
    elapsed <- as.numeric(seconds_elapsed - starts[pos])
    since <- if (is.na(prev_end[row_idx])) {
      as.numeric(300L + seconds_elapsed)
    } else {
      as.numeric(seconds_elapsed - prev_end[row_idx])
    }
    c(remaining, elapsed, since)
  }

  for (i in seq_len(n)) {
    for (j in seq_len(slot_count + 1L)) {
      home_vals <- lookup_player(
        play_by_play$gameId[i],
        play_by_play$periodNumber[i],
        play_by_play$secondsElapsedInPeriod[i],
        home_request[i, j]
      )
      away_vals <- lookup_player(
        play_by_play$gameId[i],
        play_by_play$periodNumber[i],
        play_by_play$secondsElapsedInPeriod[i],
        away_request[i, j]
      )
      home_remaining[i, j] <- home_vals[1L]
      home_elapsed[i, j] <- home_vals[2L]
      home_since[i, j] <- home_vals[3L]
      away_remaining[i, j] <- away_vals[1L]
      away_elapsed[i, j] <- away_vals[2L]
      away_since[i, j] <- away_vals[3L]
    }
  }

  list(
    homeRemaining = home_remaining,
    awayRemaining = away_remaining,
    homeElapsed = home_elapsed,
    awayElapsed = away_elapsed,
    homeSinceLast = home_since,
    awaySinceLast = away_since
  )
}

#' Compute on-ice shift timing matrices
#'
#' `.compute_on_ice_shift_timing_matrices()` uses the native timing resolver
#' when available and falls back to the R implementation otherwise.
#'
#' @param play_by_play data.frame play-by-play object with on-ice player IDs
#' @param shift_data data.frame shift chart data
#' @returns list containing home and away timing matrices
#' @keywords internal
.compute_on_ice_shift_timing_matrices <- function(play_by_play, shift_data) {
  shift_data <- .sort_shift_chart_for_timing(shift_data)
  if (
    !.ensure_local_native_symbol('nhlscraper_on_ice_shift_timings') ||
      !nrow(play_by_play)
  ) {
    return(.compute_on_ice_shift_timing_in_r(play_by_play, shift_data))
  }

  slot_count <- .on_ice_skater_slots(play_by_play = play_by_play)
  home_request <- cbind(
    as.integer(play_by_play$homeGoaliePlayerId),
    as.matrix(play_by_play[, paste0('homeSkater', seq_len(slot_count), 'PlayerId'), drop = FALSE])
  )
  away_request <- cbind(
    as.integer(play_by_play$awayGoaliePlayerId),
    as.matrix(play_by_play[, paste0('awaySkater', seq_len(slot_count), 'PlayerId'), drop = FALSE])
  )
  storage.mode(home_request) <- 'integer'
  storage.mode(away_request) <- 'integer'

  tryCatch(
    .Call('nhlscraper_on_ice_shift_timings', list(
      as.integer(play_by_play$gameId),
      as.integer(play_by_play$periodNumber),
      as.integer(play_by_play$secondsElapsedInPeriod),
      home_request,
      away_request,
      as.integer(shift_data$gameId),
      as.integer(shift_data$period),
      as.integer(shift_data$playerId),
      as.integer(shift_data$startSecondsElapsedInPeriod),
      as.integer(shift_data$endSecondsElapsedInPeriod)
    )),
    error = function(e) .compute_on_ice_shift_timing_in_r(play_by_play, shift_data)
  )
}

#' Assign scalar on-ice timing metrics
#'
#' `.assign_on_ice_shift_metric()` copies goalie and skater timing matrices into
#' home, away, for, and against scalar play-by-play columns.
#'
#' @param play_by_play data.frame play-by-play object
#' @param home_matrix numeric matrix for home on-ice players
#' @param away_matrix numeric matrix for away on-ice players
#' @param metric_suffix scalar timing suffix
#' @returns data.frame with timing columns assigned
#' @keywords internal
.assign_on_ice_shift_metric <- function(
  play_by_play,
  home_matrix,
  away_matrix,
  metric_suffix
) {
  slot_count <- max(0L, ncol(home_matrix) - 1L)
  home_cols <- c(
    paste0('homeGoalie', metric_suffix),
    paste0('homeSkater', seq_len(slot_count), metric_suffix)
  )
  away_cols <- c(
    paste0('awayGoalie', metric_suffix),
    paste0('awaySkater', seq_len(slot_count), metric_suffix)
  )
  for_cols <- c(
    paste0('goalie', metric_suffix, 'For'),
    paste0('skater', seq_len(slot_count), metric_suffix, 'For')
  )
  against_cols <- c(
    paste0('goalie', metric_suffix, 'Against'),
    paste0('skater', seq_len(slot_count), metric_suffix, 'Against')
  )
  for (j in seq_along(home_cols)) {
    play_by_play[[home_cols[j]]] <- home_matrix[, j]
    play_by_play[[away_cols[j]]] <- away_matrix[, j]
    vals_for <- rep(NA_real_, nrow(play_by_play))
    vals_against <- rep(NA_real_, nrow(play_by_play))
    home_idx <- play_by_play$isHome %in% TRUE
    away_idx <- play_by_play$isHome %in% FALSE
    vals_for[home_idx] <- home_matrix[home_idx, j]
    vals_for[away_idx] <- away_matrix[away_idx, j]
    vals_against[home_idx] <- away_matrix[home_idx, j]
    vals_against[away_idx] <- home_matrix[away_idx, j]
    play_by_play[[for_cols[j]]] <- vals_for
    play_by_play[[against_cols[j]]] <- vals_against
  }
  play_by_play
}

#' Add on-ice shift timing context
#'
#' `.add_on_ice_shift_timing_context()` enriches play-by-play rows with scalar
#' shift elapsed and since-last-shift columns for the on-ice goalies and
#' skaters.
#'
#' @param play_by_play data.frame play-by-play object with on-ice player IDs
#' @param game game ID
#' @param shift_data optional shift chart data.frame
#' @returns data.frame with scalar on-ice timing columns added
#' @keywords internal
.add_on_ice_shift_timing_context <- function(
  play_by_play,
  game,
  shift_data = NULL
) {
  if (is.null(shift_data)) {
    return(play_by_play)
  }
  .require_public_pbp_columns(play_by_play, 'periodNumber', 'add_shift_times')
  add_shift_times(play_by_play, shift_data)
}
