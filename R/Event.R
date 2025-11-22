#' Get the replay of an event
#' 
#' `ns_event_replay()` retrieves ...
#' 
#' @return data.frame with one row per decisecond
#' @examples
#' Gabriel_Landeskog_first_regular_goal_back_replay <- ns_event_replay(
#'   game  = 2025020262,
#'   event = 751
#' )
#' @export

ns_event_replay <- function(game, event) {
  base   <- 'https://wsr.nhle.com/'
  year   <- game %/% 1e6
  season <- paste0(as.character(year), as.character(year+1))
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
