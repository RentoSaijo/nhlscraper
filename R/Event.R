#' Access the replay for an event
#'
#' `replay()` retrieves the replay for an event as a `data.frame` where each row represents decisecond and includes detail on team identity, affiliation, and matchup-side context plus player identity, role, handedness, and biographical profile.
#'
#' @param game integer ID (e.g., 2025020262); see [games()] for reference
#' @param event integer ID (e.g., 751); see [gc_play_by_play()] and/or 
#' [wsc_play_by_play()] for reference; must be a 'goal' event
#'
#' @returns data.frame with one row per decisecond
#' @examples
#' Gabriel_Landeskog_first_regular_goal_back_replay <- replay(
#'   game  = 2025020262,
#'   event = 751
#' )
#' @export

replay <- function(game = 2023030417, event = 866) {
  tryCatch(
    expr = {
      to_num <- function(x) suppressWarnings(as.numeric(x))
      to_replay_x_coord <- function(x_raw) {
        x_raw <- to_num(x_raw)
        (x_raw / 12) - 100
      }
      to_replay_y_coord <- function(y_raw) {
        y_raw <- to_num(y_raw)
        42.5 - (y_raw / 12)
      }
      is_missing_chr <- function(x) {
        x_chr <- trimws(as.character(x))
        is.na(x_chr) | x_chr == ''
      }
      base   <- 'https://wsr.nhle.com/'
      year   <- game %/% 1e6
      season <- paste0(as.character(year), as.character(year + 1))
      url    <- sprintf(
        '%ssprites/%s/%s/ev%s.json',
        base,
        season,
        game,
        event
      )
      req <- httr2::request(url)
      req <- httr2::req_headers(
        req,
        referer      = 'https://www.nhl.com/',
        'user-agent' = 'Chrome/130.0.0.0'
      )
      req <- httr2::req_retry(
        req,
        max_tries    = 3,
        backoff      = function(attempt) 2 ^ (attempt - 1),
        is_transient = function(resp) httr2::resp_status(resp) == 429
      )
      resp   <- httr2::req_perform(req)
      replay <- jsonlite::fromJSON(
        httr2::resp_body_string(resp, encoding = 'UTF-8'),
        simplifyVector = TRUE,
        flatten        = TRUE
      )
      id_cols <- grep('^onIce\\.[^.]+\\.id$', names(replay), value = TRUE)
      if (!length(id_cols)) {
        return(data.frame(timeStamp = replay$timeStamp))
      }
      slots <- sub('\\.id$', '', id_cols)
      get_slot_col <- function(slot, field) {
        col <- paste0(slot, '.', field)
        if (col %in% names(replay)) replay[[col]] else rep(NA, nrow(replay))
      }
      puck_candidates <- vapply(
        slots,
        function(slot) {
          player_id <- get_slot_col(slot, 'playerId')
          x_raw  <- to_num(get_slot_col(slot, 'x'))
          y_raw  <- to_num(get_slot_col(slot, 'y'))
          id_raw <- to_num(get_slot_col(slot, 'id'))
          all(is_missing_chr(player_id)) &&
            (any(!is.na(x_raw)) || any(!is.na(y_raw))) &&
            (grepl('^onIce\\.1$', slot) || any(id_raw == 1, na.rm = TRUE))
        },
        logical(1)
      )
      if (any(puck_candidates)) {
        puck_slot <- slots[which(puck_candidates)[1]]
      } else {
        fallback <- vapply(
          slots,
          function(slot) {
            player_id <- get_slot_col(slot, 'playerId')
            x_raw <- to_num(get_slot_col(slot, 'x'))
            y_raw <- to_num(get_slot_col(slot, 'y'))
            all(is_missing_chr(player_id)) &&
              (any(!is.na(x_raw)) || any(!is.na(y_raw)))
          },
          logical(1)
        )
        if (any(fallback)) {
          puck_slot <- slots[which(fallback)[1]]
        } else if ('onIce.1' %in% slots) {
          puck_slot <- 'onIce.1'
        } else {
          puck_slot <- slots[1]
        }
      }
      out <- data.frame(timeStamp = replay$timeStamp, stringsAsFactors = FALSE)
      puck_x_raw <- to_num(get_slot_col(puck_slot, 'x'))
      puck_y_raw <- to_num(get_slot_col(puck_slot, 'y'))
      out$puckXCoordRaw <- puck_x_raw
      out$puckYCoordRaw <- puck_y_raw
      out$puckXCoord <- to_replay_x_coord(puck_x_raw)
      out$puckYCoord <- to_replay_y_coord(puck_y_raw)
      player_slots   <- slots[slots != puck_slot]
      for (i in seq_along(player_slots)) {
        slot  <- player_slots[i]
        stem  <- paste0('player', i)
        x_raw <- to_num(get_slot_col(slot, 'x'))
        y_raw <- to_num(get_slot_col(slot, 'y'))
        out[[paste0(stem, 'PPTId')]] <- to_num(get_slot_col(slot, 'id'))
        out[[paste0(stem, 'PlayerId')]]  <- to_num(get_slot_col(slot, 'playerId'))
        out[[paste0(stem, 'XCoordRaw')]] <- x_raw
        out[[paste0(stem, 'YCoordRaw')]] <- y_raw
        out[[paste0(stem, 'XCoord')]] <- to_replay_x_coord(x_raw)
        out[[paste0(stem, 'YCoord')]] <- to_replay_y_coord(y_raw)
        out[[paste0(stem, 'TeamId')]] <- to_num(get_slot_col(slot, 'teamId'))
        out[[paste0(stem, 'TeamTriCode')]] <- as.character(get_slot_col(slot, 'teamAbbrev'))
      }
      out
    },
    error = function(e) {
      message(paste(
        'Invalid argument(s); refer to help file.',
        '\nProvided game:',
        game,
        '\nProvided event:',
        event
      ))
    }
  )
}

#' Access all the penalty shots
#'
#' `penalty_shots()` retrieves all the penalty shots as a `data.frame` where each row represents penalty shot and includes detail on game timeline state, period/clock progression, and matchup flow plus date/season filtering windows and chronological context.
#'
#' @returns data.frame with one row per penalty shot
#' @examples
#' all_pss <- penalty_shots()
#' @export

penalty_shots <- function() {
  tryCatch({
    pss    <- nhl_api(
      path = 'penalty-shots',
      type = 'r'
    )$data
    pss$id <- NULL
    pss    <- pss[order(pss$gameId), ]
    names(pss)[names(pss) == 'season']   <- 'seasonId'
    names(pss)[names(pss) == 'gameType'] <- 'gameTypeId'
    names(pss) <- normalize_team_abbrev_cols(names(pss))
    pss
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname penalty_shots
#' @export

pss <- function() {
  penalty_shots()
}
