#' Call NHL API with 429 (rate limit) error-handling
#' 
#' @param path character
#' @param query list
#' @param type character (e.g. 'w' for web, 's' for stats, 'r' for records)
#' @return parsed JSON
#' @keywords internal

nhl_api <- function(path, query = list(), type) {
  base <- switch(
    type, 
    w = 'https://api-web.nhle.com/',
    s = 'https://api.nhle.com/stats/rest/',
    r = 'https://records.nhl.com/site/api/'
  )
  req <- httr2::request(paste0(base, path))
  req <- do.call(httr2::req_url_query, c(list(req), query))
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

#' Call ESPN API
#' 
#' @param path String
#' @param query list
#' @param type integer where 1=site.api and 2=sports.core
#' @return parsed JSON
#' @keywords internal

espn_api <- function(path, query=list(), type) {
  if (type==1) {
    base <- 'https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/'
  }
  else {
    base <- 'https://sports.core.api.espn.com/v2/sports/hockey/leagues/nhl/'
  }
  url <- paste0(base, path)
  resp <- httr::GET(url, query=query)
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=TRUE, flatten=TRUE))
}

normalize_team_key <- function(x) {
  x <- as.character(x)
  x <- tolower(trimws(x))
  x <- gsub('[^a-z0-9]', '', x)
  x
}

to_team_tri_code <- function(team, lookup = .to_team_tri_code) {
  unname(lookup[normalize_team_key(team)])
}

to_team_id <- function(team, lookup = .to_team_id) {
  unname(lookup[normalize_team_key(team)])
}

to_game_type_id <- function(game_type) {
  switch(
    tolower(as.character(game_type)),
    `1`     = 1,
    pre     = 1,
    `2`     = 2,
    regular = 2,
    `3`     = 3,
    playoff = 3,
    post    = 3,
    ''
  )
}
