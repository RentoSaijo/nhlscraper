#' Call the NHL API with 429 (rate limit) error-handling
#' 
#' @param path character
#' @param query list
#' @param type character of 'w' for web, 's' for stats, and 'r' for records
#' @returns parsed JSON (i.e., data.frame or list)
#' @keywords internal

nhl_api <- function(path, query = list(), type) {
  tryCatch({
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
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    list()
  })
}

#' Call the ESPN API with 429 (rate limit) error-handling
#' 
#' @param path character
#' @param query list
#' @param type character of 'g' for general and 'c' for core
#' @returns parsed JSON (i.e., data.frame or list)
#' @keywords internal

espn_api <- function(path, query = list(), type) {
  tryCatch({
    base <- switch(
      type, 
      g = 'https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/',
      c = 'https://sports.core.api.espn.com/v2/sports/hockey/leagues/nhl/'
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
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    list()
  })
}

#' Convert to the appropriate game type ID
#' 
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @returns integer in 1:3
#' @keywords internal

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

#' Normalize the team key
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @returns integer in 1:68, character full name, OR three-letter code
#' @keywords internal

normalize_team_key <- function(team) {
  gsub('[^a-z0-9]', '', tolower(trimws(as.character(team))))
}

#' Convert to the appropriate team three-letter code
#'
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @returns three-letter code
#' @keywords internal

to_team_tri_code <- function(team, lookup = .to_team_tri_code) {
  unname(lookup[normalize_team_key(team)])
}

#' Convert to the appropriate team ID
#'
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @returns integer in 1:68
#' @keywords internal

to_team_id <- function(team, lookup = .to_team_id) {
  unname(lookup[normalize_team_key(team)])
}
