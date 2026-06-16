# ----- API Helpers ----- #

#' Call the NHL API
#'
#' `nhl_api()` performs a retrying request against one of the NHL API hosts and
#' parses the JSON response with the package's standard flattening rules.
#'
#' @param path character path relative to the selected API host
#' @param query named list of URL query parameters
#' @param type character of 'w' for the web API, 's' for the stats API, or 'r'
#'   for the records API
#' @returns parsed JSON object, usually a data.frame or nested list
#' @keywords internal

nhl_api <- function(path, query = list(), type) {
  .nhl_json_from_response(
    httr2::req_perform(.nhl_request(path = path, query = query, type = type))
  )
}

#' Add the package retry policy to a request
#'
#' `.request_with_retry()` retries transient 429 rate-limit responses with a
#' short exponential backoff.
#'
#' @param req httr2 request object
#' @returns httr2 request object
#' @keywords internal

.request_with_retry <- function(req) {
  httr2::req_retry(
    req,
    max_tries = 3,
    backoff = function(attempt) 2 ^ (attempt - 1),
    is_transient = function(resp) httr2::resp_status(resp) == 429
  )
}

#' Build a retrying API request
#'
#' `.api_request()` appends URL query parameters to a host/path pair and applies
#' the package retry policy.
#'
#' @param base_url character API host
#' @param path character path relative to `base_url`
#' @param query named list of URL query parameters
#' @returns httr2 request object
#' @keywords internal

.api_request <- function(base_url, path, query = list()) {
  req <- httr2::request(paste0(base_url, path))
  req <- do.call(httr2::req_url_query, c(list(req), query))
  .request_with_retry(req)
}

#' Build an NHL API request
#'
#' `.nhl_request()` selects the requested NHL API host and constructs a retrying
#' request object. It is used by public wrappers that need to fetch requests in
#' parallel before parsing the body.
#'
#' @param path character
#' @param query list
#' @param type character of 'w' for web, 's' for stats, and 'r' for records
#' @returns httr2 request object
#' @keywords internal

.nhl_request <- function(path, query = list(), type) {
  base <- switch(
    type,
    w = 'https://api-web.nhle.com/',
    s = 'https://api.nhle.com/stats/rest/',
    r = 'https://records.nhl.com/site/api/'
  )
  .api_request(base, path, query)
}

#' Parse an NHL API response as JSON
#'
#' `.nhl_json_from_response()` converts an `httr2` response object into parsed
#' JSON using the package's standard UTF-8 and flattening settings.
#'
#' @param resp httr2 response object
#' @returns parsed JSON (i.e., data.frame or list)
#' @keywords internal

.nhl_json_from_response <- function(resp) {
  jsonlite::fromJSON(
    httr2::resp_body_string(resp, encoding = 'UTF-8'),
    simplifyVector = TRUE,
    flatten = TRUE
  )
}

#' Build an HTML report request
#'
#' `.html_report_request()` constructs an HTML report request with the same retry
#' policy used for API calls.
#'
#' @param url character scalar
#' @returns httr2 request object
#' @keywords internal

.html_report_request <- function(url) {
  .request_with_retry(httr2::request(url))
}

#' Perform multiple requests concurrently
#'
#' `.perform_parallel_requests()` executes a list of `httr2` requests with
#' libcurl multi support and preserves the input names on the output.
#'
#' @param reqs list of httr2 request objects
#' @param on_error forwarded to [httr2::req_perform_parallel()]
#' @returns list of responses or httr2 failure objects
#' @keywords internal

.perform_parallel_requests <- function(reqs, on_error = c('stop', 'return', 'continue')) {
  on_error <- match.arg(on_error)
  req_names <- names(reqs)
  out <- httr2::req_perform_parallel(
    unname(reqs),
    on_error = on_error,
    progress = FALSE
  )
  if (!is.null(req_names)) {
    names(out) <- req_names
  }
  out
}

#' Call the ESPN API
#'
#' `espn_api()` performs a retrying request against the ESPN site or core API
#' and parses the JSON response with the same flattening rules used for NHL API
#' calls.
#'
#' @param path character path relative to the selected ESPN API host
#' @param query named list of URL query parameters
#' @param type character of 'g' for the site API or 'c' for the core API
#' @returns parsed JSON object, usually a data.frame or nested list
#' @keywords internal

espn_api <- function(path, query = list(), type) {
  base <- switch(
    type,
    g = 'https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/',
    c = 'https://sports.core.api.espn.com/v2/sports/hockey/leagues/nhl/'
  )
  .nhl_json_from_response(
    httr2::req_perform(.api_request(base, path, query))
  )
}

# ----- ID Helpers ----- #

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

# ----- Name Helpers ----- #

#' Convert dot-delimited names to camelCase
#'
#' @param x character vector
#' @returns character vector
#' @keywords internal

dot_to_camel <- function(x) {
  parts <- strsplit(x, '\\.')
  vapply(parts, function(p) {
    if (length(p) == 1L) return(p)
    paste0(
      p[1],
      paste0(
        toupper(substr(p[-1], 1, 1)),
        substr(p[-1], 2, nchar(p[-1])),
        collapse = ''
      )
    )
  }, character(1))
}

#' Normalize locale-style dotted columns to camelCase
#'
#' Converts dotted names (e.g., firstName.default, name.cs) to camelCase and
#' removes trailing `Default` from default-language fields.
#'
#' @param x character vector
#' @returns character vector
#' @keywords internal

normalize_locale_names <- function(x) {
  x <- dot_to_camel(x)
  sub('Default$', '', x)
}

#' Scope generic person-name columns to an entity
#'
#' @param x character vector
#' @param prefix character scalar (e.g., 'player', 'goalie', 'skater')
#' @returns character vector
#' @keywords internal

scope_person_name_cols <- function(x, prefix) {
  x <- gsub('^firstName([A-Z].*)?$', paste0(prefix, 'FirstName\\1'), x, perl = TRUE)
  x <- gsub('^lastName([A-Z].*)?$', paste0(prefix, 'LastName\\1'), x, perl = TRUE)
  x <- gsub('^fullName([A-Z].*)?$', paste0(prefix, 'FullName\\1'), x, perl = TRUE)
  x <- gsub('^name([A-Z].*)?$', paste0(prefix, 'Name\\1'), x, perl = TRUE)
  x
}

#' Normalize team abbreviation columns to team tri-code names
#'
#' @param x character vector
#' @returns character vector
#' @keywords internal

normalize_team_abbrev_cols <- function(x) {
  x <- sub('TeamAbbreviations$', 'TeamTriCodes', x, perl = TRUE)
  x <- sub('TeamAbbreviation$', 'TeamTriCode', x, perl = TRUE)
  x <- sub('TeamAbbrevs$', 'TeamTriCodes', x, perl = TRUE)
  x <- sub('TeamAbbrev$', 'TeamTriCode', x, perl = TRUE)
  map <- c(
    opponentAbbrev    = 'opponentTeamTriCode',
    teamAbbreviation  = 'teamTriCode',
    teamAbbreviations = 'teamTriCodes',
    teamAbbrev        = 'teamTriCode',
    teamAbbrevs       = 'teamTriCodes'
  )
  idx <- match(x, names(map))
  x[!is.na(idx)] <- unname(map[idx[!is.na(idx)]])
  x
}
