#' Calculate the expected goals for all the shots in (a) play-by-plays
#'
#' `calculate_expected_goals()` scores shot events with `nhlscraper`'s built-in
#' ridge expected-goals model. The runtime model is a fixed six-partition system:
#' `sd` (5v5), `ev` (other even strength), `pp` (power play), `sh`
#' (short-handed), `en` (empty net against), and `ps` (penalty shot; trained on
#' penalty-shot and shootout-style rows). The legacy `model` argument is
#' accepted for backward compatibility but ignored.
#'
#' @param play_by_play data.frame of play-by-play(s) using the current public
#'   schema returned by [gc_play_by_play()], [gc_play_by_plays()],
#'   [wsc_play_by_play()], or [wsc_play_by_plays()]. Legacy alias-only columns
#'   such as `typeDescKey`, `period`, `SOGFor`, `SOGAgainst`, and
#'   `SOGDifferential` are no longer backfilled by the xG scorer.
#' @param model deprecated legacy model selector; ignored
#' @returns data.frame with one row per event (play) and added `xG` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   pbp <- gc_play_by_play()
#'   pbp_with_xg <- calculate_expected_goals(play_by_play = pbp)
#' }
#' @export
calculate_expected_goals <- function(play_by_play, model = NULL) {
  tryCatch(
    expr = {
      .xg_warn_ignored_model(model, "calculate_expected_goals")

      pbp <- .xg_prepare_play_by_play(play_by_play)
      n <- nrow(pbp)
      xg <- rep(NA_real_, n)

      is_shot <- .shot_event_mask(
        pbp,
        c("goal", "shot-on-goal", "missed-shot")
      )
      if (!any(is_shot)) {
        play_by_play$xG <- xg
        return(play_by_play)
      }

      shot_idx <- which(is_shot)
      shots <- .xg_build_model_frame(
        shots = pbp[shot_idx, , drop = FALSE],
        play_by_play = pbp
      )

      partition <- .xg_partition_shots(shots)
      goalie_ids <- unique(
        as.integer(
          pbp$goaliePlayerIdAgainst[!is.na(pbp$goaliePlayerIdAgainst)]
        )
      )
      shooter_ids <- as.integer(shots$shootingPlayerId)
      score_ok <- is.na(shooter_ids) | !(shooter_ids %in% goalie_ids)

      for (key in names(XG_RIDGE_MODEL_SPECS)) {
        idx <- which(score_ok & !is.na(partition) & partition == key)
        if (!length(idx)) {
          next
        }
        xg[shot_idx[idx]] <- .xg_score_partition(
          shots[idx, , drop = FALSE],
          XG_RIDGE_MODEL_SPECS[[key]]
        )
      }

      play_by_play$xG <- xg
      play_by_play
    },
    error = function(e) {
      message(conditionMessage(e))
      message("Invalid argument(s); refer to help file.")
      play_by_play
    }
  )
}

#' @rdname calculate_expected_goals
#' @export
calculate_xG <- function(play_by_play, model = NULL) {
  calculate_expected_goals(play_by_play, model)
}

.xg_warn_ignored_model <- function(model, fn_name) {
  if (missing(model) || is.null(model)) {
    return(invisible(NULL))
  }
  model_value <- suppressWarnings(as.integer(model[[1L]]))
  if (!is.na(model_value) && identical(model_value, 1L)) {
    return(invisible(NULL))
  }
  warning(
    sprintf(
      "`%s()` now uses one built-in six-partition ridge xG model; `model` is ignored.",
      fn_name
    ),
    call. = FALSE
  )
  invisible(NULL)
}

.xg_require_current_public_schema <- function(play_by_play) {
  legacy_aliases <- c(
    eventTypeDescKey = "typeDescKey",
    periodNumber = "period",
    shotsFor = "SOGFor",
    shotsAgainst = "SOGAgainst",
    shotDifferential = "SOGDifferential"
  )
  legacy_only <- names(legacy_aliases)[vapply(
    names(legacy_aliases),
    function(nm) {
      alt <- legacy_aliases[[nm]]
      !(nm %in% names(play_by_play)) && alt %in% names(play_by_play)
    },
    logical(1)
  )]

  if (length(legacy_only)) {
    replacements <- paste(
      sprintf(
        "%s -> %s",
        unname(legacy_aliases[legacy_only]),
        legacy_only
      ),
      collapse = ", "
    )
    stop(
      paste0(
        "calculate_expected_goals() requires the current public play-by-play schema. ",
        "Replace legacy xG alias columns with their public names: ",
        replacements
      ),
      call. = FALSE
    )
  }

  .require_public_pbp_columns(
    play_by_play,
    c(
      "gameId",
      "eventId",
      "sortOrder",
      "gameTypeId",
      "periodNumber",
      "eventOwnerTeamId",
      "eventTypeDescKey",
      "situationCode"
    ),
    "calculate_expected_goals"
  )

  invisible(NULL)
}

.xg_fill_goalie_against_fallback <- function(play_by_play) {
  if ("goalieInNetId" %in% names(play_by_play)) {
    goalie_in_net <- suppressWarnings(as.integer(play_by_play$goalieInNetId))
    if ("goaliePlayerIdAgainst" %in% names(play_by_play)) {
      goalie_against <- suppressWarnings(as.integer(play_by_play$goaliePlayerIdAgainst))
      play_by_play$goaliePlayerIdAgainst <- dplyr::coalesce(goalie_in_net, goalie_against)
    } else {
      play_by_play$goaliePlayerIdAgainst <- goalie_in_net
    }
  }
  play_by_play
}

.xg_required_shift_cols <- function(play_by_play) {
  id_cols <- grep(
    "^(?:home|away)Skater[0-9]+PlayerId$|^skater[0-9]+PlayerId(?:For|Against)$",
    names(play_by_play),
    value = TRUE
  )
  if (!length(id_cols)) {
    return(character())
  }
  slot_count <- .on_ice_skater_slots(play_by_play = play_by_play)
  if (!slot_count) {
    return(character())
  }
  c(
    paste0("skater", seq_len(slot_count), "SecondsElapsedInShiftFor"),
    paste0("skater", seq_len(slot_count), "SecondsElapsedInShiftAgainst"),
    paste0("skater", seq_len(slot_count), "SecondsElapsedInPeriodSinceLastShiftFor"),
    paste0("skater", seq_len(slot_count), "SecondsElapsedInPeriodSinceLastShiftAgainst")
  )
}

.xg_fetch_shift_data <- function(game_ids) {
  game_ids <- sort(unique(as.integer(game_ids[!is.na(game_ids)])))
  if (!length(game_ids)) {
    return(data.frame())
  }

  if (length(game_ids) <= 4L) {
    out <- vector("list", length(game_ids))
    for (i in seq_along(game_ids)) {
      out[[i]] <- tryCatch(
        shift_chart(game_ids[[i]]),
        error = function(e) data.frame()
      )
    }
    out <- Filter(
      function(x) is.data.frame(x) && nrow(x) > 0L,
      out
    )
    if (!length(out)) {
      return(data.frame())
    }
    return(do.call(rbind, out))
  }

  season_ids <- sort(unique(game_ids %/% 1e6 * 1e4 + game_ids %/% 1e6 + 1L))
  out <- vector("list", length(season_ids))
  for (i in seq_along(season_ids)) {
    sc <- tryCatch(
      shift_charts(season_ids[[i]]),
      error = function(e) data.frame()
    )
    if (is.data.frame(sc) && nrow(sc) > 0L && "gameId" %in% names(sc)) {
      sc <- sc[sc$gameId %in% game_ids, , drop = FALSE]
    }
    out[[i]] <- sc
  }
  out <- Filter(
    function(x) is.data.frame(x) && nrow(x) > 0L,
    out
  )
  if (!length(out)) {
    data.frame()
  } else {
    do.call(rbind, out)
  }
}

.xg_prepare_play_by_play <- function(play_by_play) {
  .xg_require_current_public_schema(play_by_play)
  pbp <- .xg_fill_goalie_against_fallback(play_by_play)

  if (!("isHome" %in% names(pbp))) {
    pbp <- .flag_is_home(pbp)
  }

  state_cols <- c(
    "isEmptyNetFor",
    "isEmptyNetAgainst",
    "skaterCountFor",
    "skaterCountAgainst",
    "manDifferential",
    "strengthState"
  )
  if (!all(state_cols %in% names(pbp))) {
    pbp <- .strip_situation_code(pbp)
  }

  need_context <- !all(c(
    "isRush",
    "isRebound",
    "goalsFor",
    "goalsAgainst",
    "shotsFor",
    "shotsAgainst",
    "shotDifferential",
    "fenwickFor",
    "fenwickAgainst",
    "fenwickDifferential",
    "corsiFor",
    "corsiAgainst",
    "corsiDifferential"
  ) %in% names(pbp))
  if (need_context) {
    pbp <- .apply_shot_context(pbp)
  }

  shift_cols <- .xg_required_shift_cols(pbp)
  if (length(shift_cols) && !all(shift_cols %in% names(pbp))) {
    shifts <- .xg_fetch_shift_data(pbp$gameId)
    if (nrow(shifts) > 0L) {
      pbp <- tryCatch(
        add_shift_times(pbp, shifts),
        error = function(e) pbp
      )
    }
  }

  if (!all(.pbp_delta_public_cols() %in% names(pbp))) {
    pbp <- add_deltas(pbp)
  }

  if (!all(c(
    "shooterHeight",
    "shooterWeight",
    "shooterHandCode",
    "shooterPositionCode",
    "shooterAge"
  ) %in% names(pbp))) {
    pbp <- add_shooter_biometrics(pbp)
  }

  if (!all(c(
    "goalieHeight",
    "goalieWeight",
    "goalieHandCode",
    "goalieAge"
  ) %in% names(pbp))) {
    pbp <- add_goalie_biometrics(pbp)
  }

  .xg_fill_goalie_against_fallback(pbp)
}

.xg_normalize_shot_type <- function(x) {
  x <- tolower(trimws(as.character(x)))
  keep <- c("backhand", "deflected", "slap", "snap", "tip-in", "wrist")
  ifelse(!is.na(x) & x %in% keep, x, "other")
}

.xg_normalize_missed_reason <- function(x) {
  x <- tolower(trimws(as.character(x)))
  out <- rep("other", length(x))
  out[!is.na(x) & x %in% c(
    "goalpost", "hit-left-post", "hit-right-post", "hit-crossbar"
  )] <- "post"
  out[!is.na(x) & x %in% c("over-net", "above-crossbar")] <- "high"
  out[!is.na(x) & x %in% c(
    "wide-of-net",
    "high-and-wide-left",
    "high-and-wide-right",
    "wide-left",
    "wide-right"
  )] <- "wide"
  out
}

.xg_make_type_desc_key_prev <- function(
  type_desc_key_prev,
  reason_prev,
  shot_type_prev,
  event_owner_team_id_prev,
  event_owner_team_id
) {
  n <- length(type_desc_key_prev)
  out <- rep(NA_character_, n)
  prev_type <- tolower(as.character(type_desc_key_prev))
  reason_prev <- .xg_normalize_missed_reason(reason_prev)
  shot_type_prev <- .xg_normalize_shot_type(shot_type_prev)
  is_for <- !is.na(event_owner_team_id_prev) &
    !is.na(event_owner_team_id) &
    event_owner_team_id_prev == event_owner_team_id

  idx <- !is.na(prev_type) & prev_type == "faceoff" & is_for
  out[idx] <- "won-faceoff"
  idx <- !is.na(prev_type) & prev_type == "faceoff" & !is_for
  out[idx] <- "lost-faceoff"

  idx <- !is.na(prev_type) & prev_type == "shot-on-goal" & is_for
  out[idx] <- paste0(shot_type_prev[idx], "-shot-on-goal-for")
  idx <- !is.na(prev_type) & prev_type == "shot-on-goal" & !is_for
  out[idx] <- paste0(shot_type_prev[idx], "-shot-on-goal-against")

  idx <- !is.na(prev_type) & prev_type == "hit" & is_for
  out[idx] <- "given-hit"
  idx <- !is.na(prev_type) & prev_type == "hit" & !is_for
  out[idx] <- "taken-hit"

  idx <- !is.na(prev_type) & prev_type == "blocked-shot" & is_for
  out[idx] <- "blocked-shot-for"
  idx <- !is.na(prev_type) & prev_type == "blocked-shot" & !is_for
  out[idx] <- "blocked-shot-against"

  idx <- !is.na(prev_type) & prev_type == "giveaway" & is_for
  out[idx] <- "giveaway-for"
  idx <- !is.na(prev_type) & prev_type == "giveaway" & !is_for
  out[idx] <- "giveaway-against"

  idx <- !is.na(prev_type) & prev_type == "takeaway" & is_for
  out[idx] <- "takeaway-for"
  idx <- !is.na(prev_type) & prev_type == "takeaway" & !is_for
  out[idx] <- "takeaway-against"

  idx <- !is.na(prev_type) & prev_type == "missed-shot" & is_for
  out[idx] <- paste0(reason_prev[idx], "-missed-shot-for")
  idx <- !is.na(prev_type) & prev_type == "missed-shot" & !is_for
  out[idx] <- paste0(reason_prev[idx], "-missed-shot-against")

  other <- is.na(out) & !is.na(prev_type)
  out[other] <- prev_type[other]
  out
}

.xg_extract_slot_indices <- function(data, suffix) {
  matches <- regexec(
    paste0("^skater([0-9]+)", suffix, "$"),
    names(data)
  )
  vals <- regmatches(names(data), matches)
  idx <- vapply(
    vals,
    function(x) {
      if (length(x) < 2L) {
        return(NA_integer_)
      }
      as.integer(x[[2L]])
    },
    integer(1L)
  )
  sort(unique(idx[!is.na(idx)]))
}

.xg_build_skater_matrix <- function(data, suffix, mode = "numeric") {
  idx <- .xg_extract_slot_indices(data, suffix)
  if (!length(idx)) {
    out <- matrix(numeric(0), nrow = nrow(data), ncol = 0L)
    storage.mode(out) <- mode
    return(out)
  }
  cols <- paste0("skater", idx, suffix)
  out <- matrix(NA_real_, nrow = nrow(data), ncol = length(cols))
  for (j in seq_along(cols)) {
    if (cols[[j]] %in% names(data)) {
      out[, j] <- suppressWarnings(as.numeric(data[[cols[[j]]]]))
    }
  }
  if (identical(mode, "integer")) {
    storage.mode(out) <- "integer"
  }
  out
}

.xg_row_min <- function(mat) {
  n <- nrow(mat)
  if (!ncol(mat)) {
    return(rep(NA_real_, n))
  }
  out <- rep(Inf, n)
  any_ok <- rep(FALSE, n)
  for (j in seq_len(ncol(mat))) {
    col <- mat[, j]
    ok <- !is.na(col)
    any_ok[ok] <- TRUE
    out[ok] <- pmin(out[ok], col[ok])
  }
  out[!any_ok] <- NA_real_
  out
}

.xg_row_max <- function(mat) {
  n <- nrow(mat)
  if (!ncol(mat)) {
    return(rep(NA_real_, n))
  }
  out <- rep(-Inf, n)
  any_ok <- rep(FALSE, n)
  for (j in seq_len(ncol(mat))) {
    col <- mat[, j]
    ok <- !is.na(col)
    any_ok[ok] <- TRUE
    out[ok] <- pmax(out[ok], col[ok])
  }
  out[!any_ok] <- NA_real_
  out
}

.xg_row_mean <- function(mat) {
  if (!ncol(mat)) {
    return(rep(NA_real_, nrow(mat)))
  }
  counts <- rowSums(!is.na(mat))
  sums <- rowSums(mat, na.rm = TRUE)
  out <- sums / counts
  out[counts == 0L] <- NA_real_
  out
}

.xg_extract_matched_value <- function(id_mat, value_mat, player_id) {
  n <- nrow(id_mat)
  out <- rep(NA_real_, n)
  if (!ncol(id_mat) || !ncol(value_mat)) {
    return(out)
  }
  player_id <- suppressWarnings(as.integer(player_id))
  for (j in seq_len(ncol(id_mat))) {
    hit <- is.na(out) &
      !is.na(player_id) &
      !is.na(id_mat[, j]) &
      id_mat[, j] == player_id
    if (any(hit)) {
      out[hit] <- value_mat[hit, j]
    }
  }
  out
}

.xg_to_logical <- function(x) {
  if (is.logical(x)) {
    return(x)
  }
  if (is.numeric(x) || is.integer(x)) {
    out <- rep(NA, length(x))
    out[!is.na(x)] <- x[!is.na(x)] != 0
    return(out)
  }
  x <- as.character(x)
  out <- rep(NA, length(x))
  out[!is.na(x) & x %in% c("TRUE", "T", "true", "1", "yes", "YES")] <- TRUE
  out[!is.na(x) & x %in% c("FALSE", "F", "false", "0", "no", "NO")] <- FALSE
  out
}

.xg_build_model_frame <- function(shots, play_by_play) {
  shots <- .xg_fill_goalie_against_fallback(shots)
  play_by_play <- .xg_fill_goalie_against_fallback(play_by_play)
  n <- nrow(shots)

  prev_keys <- if ("eventIdPrev" %in% names(shots)) {
    paste(shots$gameId, shots$eventIdPrev, sep = ":")
  } else {
    rep(NA_character_, n)
  }
  cur_keys <- paste(play_by_play$gameId, play_by_play$eventId, sep = ":")
  prev_idx <- match(prev_keys, cur_keys)

  shot_type_prev <- if ("shotType" %in% names(play_by_play)) {
    .xg_normalize_shot_type(play_by_play$shotType[prev_idx])
  } else {
    rep("other", n)
  }

  shooting_player_id <- if ("shootingPlayerId" %in% names(shots)) {
    suppressWarnings(as.integer(shots$shootingPlayerId))
  } else {
    rep(NA_integer_, n)
  }
  if ("scoringPlayerId" %in% names(shots)) {
    use_scoring <- is.na(shooting_player_id)
    shooting_player_id[use_scoring] <- suppressWarnings(
      as.integer(shots$scoringPlayerId[use_scoring])
    )
  }

  if (!("gameTypeId" %in% names(shots)) && "gameId" %in% names(shots)) {
    shots$gameTypeId <- shots$gameId %/% 1e4 %% 1e2
  }

  shot_type <- if ("shotType" %in% names(shots)) {
    shots$shotType
  } else {
    rep(NA_character_, n)
  }
  period_type <- if ("periodType" %in% names(shots)) {
    shots$periodType
  } else {
    rep(NA_character_, n)
  }
  x_coord_norm <- if ("xCoordNorm" %in% names(shots)) {
    suppressWarnings(as.numeric(shots$xCoordNorm))
  } else {
    rep(NA_real_, n)
  }
  y_coord_norm <- if ("yCoordNorm" %in% names(shots)) {
    suppressWarnings(as.numeric(shots$yCoordNorm))
  } else {
    rep(NA_real_, n)
  }
  d_y_coord_norm <- if ("dYCoordNorm" %in% names(shots)) {
    suppressWarnings(as.numeric(shots$dYCoordNorm))
  } else {
    rep(NA_real_, n)
  }

  shots$shotType <- .xg_normalize_shot_type(shot_type)
  shots$typeDescKeyPrev <- .xg_make_type_desc_key_prev(
    type_desc_key_prev = play_by_play$eventTypeDescKey[prev_idx],
    reason_prev = play_by_play$reason[prev_idx],
    shot_type_prev = shot_type_prev,
    event_owner_team_id_prev = play_by_play$eventOwnerTeamId[prev_idx],
    event_owner_team_id = shots$eventOwnerTeamId
  )
  shots$shootingPlayerId <- shooting_player_id

  is_empty_for <- .xg_to_logical(
    if ("isEmptyNetFor" %in% names(shots)) shots$isEmptyNetFor else rep(NA, n)
  )
  is_empty_against <- .xg_to_logical(
    if ("isEmptyNetAgainst" %in% names(shots)) shots$isEmptyNetAgainst else rep(NA, n)
  )
  is_empty_for[is.na(is_empty_for)] <- FALSE
  is_empty_against[is.na(is_empty_against)] <- FALSE
  shots$isEmptyNetFor <- is_empty_for
  shots$isEmptyNetAgainst <- is_empty_against
  shots$isPlayoff <- !is.na(shots$gameTypeId) & shots$gameTypeId == 3L
  shots$isOvertime <- !is.na(period_type) &
    as.character(period_type) == "OT"
  shots$xCoordNorm <- x_coord_norm
  shots$yCoordNorm <- y_coord_norm
  shots$dYCoordNorm <- d_y_coord_norm
  shots$isBehindNet <- !is.na(x_coord_norm) & x_coord_norm >= 89
  y_prev <- y_coord_norm - d_y_coord_norm
  shots$crossedRoyalRoad <- !is.na(y_coord_norm) &
    !is.na(y_prev) &
    y_coord_norm * y_prev < 0

  shots$zoneCode <- if ("zoneCode" %in% names(shots)) {
    toupper(as.character(shots$zoneCode))
  } else {
    rep(NA_character_, n)
  }
  shots$strengthState <- if ("strengthState" %in% names(shots)) {
    tolower(as.character(shots$strengthState))
  } else {
    rep(NA_character_, n)
  }
  shots$shooterHandCode <- if ("shooterHandCode" %in% names(shots)) {
    toupper(as.character(shots$shooterHandCode))
  } else {
    rep(NA_character_, n)
  }
  shots$goalieHandCode <- if ("goalieHandCode" %in% names(shots)) {
    toupper(as.character(shots$goalieHandCode))
  } else {
    rep(NA_character_, n)
  }
  shots$shooterPositionCode <- if ("shooterPositionCode" %in% names(shots)) {
    toupper(as.character(shots$shooterPositionCode))
  } else {
    rep(NA_character_, n)
  }

  player_ids_for <- .xg_build_skater_matrix(shots, "PlayerIdFor", "integer")
  shift_for <- .xg_build_skater_matrix(shots, "SecondsElapsedInShiftFor")
  shift_against <- .xg_build_skater_matrix(shots, "SecondsElapsedInShiftAgainst")
  rest_for <- .xg_build_skater_matrix(shots, "SecondsElapsedInPeriodSinceLastShiftFor")
  rest_against <- .xg_build_skater_matrix(shots, "SecondsElapsedInPeriodSinceLastShiftAgainst")

  shots$minSecondsElapsedInShiftFor <- .xg_row_min(shift_for)
  shots$maxSecondsElapsedInShiftFor <- .xg_row_max(shift_for)
  shots$avgSecondsElapsedInShiftFor <- .xg_row_mean(shift_for)
  shots$minSecondsElapsedInShiftAgainst <- .xg_row_min(shift_against)
  shots$maxSecondsElapsedInShiftAgainst <- .xg_row_max(shift_against)
  shots$avgSecondsElapsedInShiftAgainst <- .xg_row_mean(shift_against)
  shots$minSecondsElapsedSinceLastShiftFor <- .xg_row_min(rest_for)
  shots$maxSecondsElapsedSinceLastShiftFor <- .xg_row_max(rest_for)
  shots$avgSecondsElapsedSinceLastShiftFor <- .xg_row_mean(rest_for)
  shots$minSecondsElapsedSinceLastShiftAgainst <- .xg_row_min(rest_against)
  shots$maxSecondsElapsedSinceLastShiftAgainst <- .xg_row_max(rest_against)
  shots$avgSecondsElapsedSinceLastShiftAgainst <- .xg_row_mean(rest_against)
  shots$shooterSecondsElapsedInShift <- .xg_extract_matched_value(
    player_ids_for,
    shift_for,
    shots$shootingPlayerId
  )
  shots$shooterSecondsElapsedSinceLastShift <- .xg_extract_matched_value(
    player_ids_for,
    rest_for,
    shots$shootingPlayerId
  )

  shots
}

.xg_partition_shots <- function(shots) {
  sc <- .normalize_situation_code_for_parse(shots$situationCode)
  is_empty_for <- .xg_to_logical(shots$isEmptyNetFor)
  is_empty_against <- .xg_to_logical(shots$isEmptyNetAgainst)
  is_empty_for[is.na(is_empty_for)] <- FALSE
  is_empty_against[is.na(is_empty_against)] <- FALSE

  skater_for <- suppressWarnings(as.integer(shots$skaterCountFor))
  skater_against <- suppressWarnings(as.integer(shots$skaterCountAgainst))

  is_ps <- !is.na(sc) & sc %in% c("1010", "0101")
  is_en <- !is_ps & is_empty_against
  is_sd_standard <- (!is_ps &
    !is_en &
    !is.na(skater_for) &
    !is.na(skater_against) &
    skater_for == 5L &
    skater_against == 5L &
    !is_empty_for &
    !is_empty_against)
  is_ev <- !is_ps &
    !is_en &
    !is.na(skater_for) &
    !is.na(skater_against) &
    skater_for == skater_against &
    !is_sd_standard
  is_pp <- !is_ps &
    !is_en &
    !is.na(skater_for) &
    !is.na(skater_against) &
    skater_for > skater_against
  is_sh <- !is_ps &
    !is_en &
    !is.na(skater_for) &
    !is.na(skater_against) &
    skater_for < skater_against
  is_uncategorizable_partition <- !(
    is_ps |
    is_en |
    is_sd_standard |
    is_ev |
    is_pp |
    is_sh
  )
  is_sd <- is_sd_standard | is_uncategorizable_partition
  is_ps[is.na(is_ps)] <- FALSE
  is_en[is.na(is_en)] <- FALSE
  is_sd[is.na(is_sd)] <- FALSE
  is_ev[is.na(is_ev)] <- FALSE
  is_pp[is.na(is_pp)] <- FALSE
  is_sh[is.na(is_sh)] <- FALSE

  out <- rep(NA_character_, nrow(shots))
  out[is_ps] <- "ps"
  out[is_en] <- "en"
  out[is_sd] <- "sd"
  out[is_ev] <- "ev"
  out[is_pp] <- "pp"
  out[is_sh] <- "sh"
  out
}

.xg_encode_categorical <- function(values, var, spec, n) {
  if (is.null(values)) {
    values <- rep(NA, n)
  }

  logical_var <- var %in% spec$logical_vars
  if (logical_var) {
    values <- .xg_to_logical(values)
    out <- rep(NA_character_, length(values))
    out[!is.na(values) & values] <- "yes"
    out[!is.na(values) & !values] <- "no"
  } else {
    out <- as.character(values)
  }

  known <- spec$known_levels[[var]]
  known <- if (is.null(known)) character() else known
  allowed <- c(
    known,
    if (isTRUE(spec$has_unknown[[var]])) "unknown",
    if (isTRUE(spec$has_new[[var]])) "new"
  )

  out[is.na(out) & isTRUE(spec$has_unknown[[var]])] <- "unknown"
  novel <- !is.na(out) & !(out %in% allowed)
  if (isTRUE(spec$has_new[[var]])) {
    out[novel] <- "new"
  }

  out
}

.xg_standardize_term <- function(x, term, spec, n) {
  if (is.null(x)) {
    x <- rep(NA_real_, n)
  }
  if (is.factor(x)) {
    x <- as.character(x)
  }
  if (is.logical(x)) {
    x <- ifelse(is.na(x), NA_real_, as.numeric(x))
  } else {
    x <- suppressWarnings(as.numeric(x))
  }

  med <- spec$medians[[term]]
  if (is.null(med) || !length(med) || is.na(med)) {
    med <- 0
  }
  x[is.na(x)] <- med

  center <- spec$normalize_means[[term]]
  scale <- spec$normalize_sds[[term]]
  if (is.null(center) || !length(center) || is.na(center)) {
    center <- 0
  }
  if (is.null(scale) || !length(scale) || !is.finite(scale) || scale == 0) {
    return(rep(0, n))
  }
  (x - center) / scale
}

.xg_score_partition <- function(df, spec) {
  n <- nrow(df)
  if (!n) {
    return(numeric(0))
  }

  coeffs <- spec$coefficients
  eta <- rep(unname(coeffs[["(Intercept)"]]), n)

  if (length(spec$raw_terms)) {
    for (term in spec$raw_terms) {
      eta <- eta + coeffs[[term]] * .xg_standardize_term(
        if (term %in% names(df)) df[[term]] else NULL,
        term,
        spec,
        n
      )
    }
  }

  if (length(spec$active_dummy_by_var)) {
    for (var in names(spec$active_dummy_by_var)) {
      values <- .xg_encode_categorical(
        if (var %in% names(df)) df[[var]] else NULL,
        var,
        spec,
        n
      )
      terms <- spec$active_dummy_by_var[[var]]
      for (term in terms) {
        level <- spec$dummy_term_to_level[[term]]
        dummy <- as.numeric(values == level)
        dummy[is.na(dummy)] <- NA_real_
        eta <- eta + coeffs[[term]] * .xg_standardize_term(
          dummy,
          term,
          spec,
          n
        )
      }
    }
  }

  stats::plogis(eta)
}
