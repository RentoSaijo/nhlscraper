#' Access the replay for an event
#' 
#' `event_replay()` scrapes the replay for a given `event`.
#' 
#' @param game integer ID (e.g., 2025020262); see [games()] for reference
#' @param event integer ID (e.g., 751); see [gc_play_by_play()] and/or 
#' [wsc_play_by_play()] for reference; must be a 'goal' event
#' @returns data.frame with one row per decisecond
#' @examples
#' Gabriel_Landeskog_first_regular_goal_back_replay <- event_replay(
#'   game  = 2025020262,
#'   event = 751
#' )
#' @export

event_replay <- function(game = 2023030417, event = 866) {
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
  resp <- httr2::req_perform(req)
  jsonlite::fromJSON(
    httr2::resp_body_string(resp, encoding = 'UTF-8'),
    simplifyVector = TRUE,
    flatten        = TRUE
  )
}

#' Access all the penalty shots
#' 
#' `penalty_shots()` scrapes information on all the penalty shots.
#' 
#' @returns data.frame with one row per penalty shot
#' @examples
#' all_ps <- penalty_shots()
#' @export

penalty_shots <- function() {
  ps <- nhl_api(
    path = 'penalty-shots',
    type = 'r'
  )$data
  ps$id <- NULL
  ps[order(ps$gameId), ]
}

#' @rdname penalty_shots
#' @export
ps <- function() {
  penalty_shots()
}
