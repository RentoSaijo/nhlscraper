#' Get the glossary
#' 
#' `ns_glossary()` retrieves information on each terminology, including but not 
#' limited to their definition and abbreviation.
#' 
#' @returns data.frame with one row per terminology
#' @examples
#' glossary <- ns_glossary()
#' @export

ns_glossary <- function() {
  nhl_api(
    path = 'en/glossary',
    type = 's'
  )$data
}

#' Get the configuration for skater, goalie, and team statistics
#' 
#' `ns_statistics_configuration()` retrieves information on the outputs of the 
#' possible combinations of inputs for `get_team_statistics()`, 
#' `get_skater_statistics()`, and `get_goalie_statistics()`.
#' 
#' @returns list with 5 items
#' @examples
#' stats_config <- ns_statistics_configuration()
#' @export

ns_statistics_configuration <- function() {
  nhl_api(
    path = 'en/config',
    type = 's'
  )
}

#' @rdname ns_statistics_configuration
#' @export
ns_stats_config <- function() {
  ns_statistics_configuration()
}

#' Get all the logos
#' 
#' `ns_logos()` ...
#' 
#' @returns data.frame with one row per venue
#' @examples
#' all_logos <- ns_logos()
#' @export

ns_logos <- function() {
  nhl_api(
    path = 'logo',
    type = 'r'
  )$data
}

#' Get all the officials
#' 
#' `ns_officials()` retrieves information on each official, including but not 
#' limited to their ID, name, and birth date and location.
#' 
#' @returns data.frame with one row per official
#' @examples
#' all_officials <- ns_officials()
#' @export

ns_officials <- function() {
  nhl_api(
    path = 'officials',
    type = 'r'
  )$data
}

#' Get all the venues
#' 
#' `ns_venues()` retrieves information on each venue, including but not limited 
#' to their ID, name, and location.
#' 
#' @returns data.frame with one row per venue
#' @examples
#' all_venues <- ns_venues()
#' @export

ns_venues <- function() {
  nhl_api(
    path = 'venue',
    type = 'r'
  )$data
}

#' Get all the countries
#' 
#' `ns_countries` retrieves information on each country, including but not 
#' limited to their ID, name, 2-letter code, and 3-letter code.
#' 
#' @returns data.frame with one row per country
#' @examples
#' all_countries <- ns_countries()
#' @export

ns_countries <- function() {
  nhl_api(
    path = 'en/country',
    type = 's'
  )$data
}

#' Get the location of a zip code
#' 
#' `ns_location()` retrieves ...
#' 
#' @param zip integer (e.g., 80204)
#' @returns data.frame with one row per team
#' @examples
#' Cranbrook_Schools <- ns_location(48304)
#' @export

ns_location <- function(zip = 80204) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/postal-lookup/%s', zip),
        type = 'w'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get all the streams
#' 
#' `ns_streams()` retrieves information on each stream, including but not 
#' limited to their ID, name, and URL.
#' 
#' @returns data.frame with one row per stream
#' @examples
#' all_streams <- ns_streams()
#' @export

ns_streams <- function() {
  nhl_api(
    path = 'v1/where-to-watch',
    type = 'w'
  )
}

#' Get the TV schedule of the NHL Network for a date
#' 
#' `ns_tv_schedule()` retrieves information on each TV program for a given 
#' `date`, including but not limited to their title, description, start and end 
#' times, and broadcast status. Access `get_seasons()` for `date` reference.
#' 
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01')
#' @returns data.frame with one row per program
#' @examples
#' tv_schedule_Halloween_2025 <- ns_tv_schedule(date = '2025-10-31')
#' @export

ns_tv_schedule <- function(date = 'now') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/network/tv-schedule/%s', date),
        type = 'w'
      )$broadcasts
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the real-time game odds by partnered bookmakers
#' 
#' `ns_partner_odds()` retrieves partner-provided information on each game for 
#' a given `country`, including but not limited to their ID and home and away 
#' team odds. Access `get_countries()` for `country` reference.
#' 
#' @param country two-letter code
#' @returns data.frame with one row per game
#' @examples
#' partner_odds_CA <- ns_partner_odds(country = 'CA')
#' @export

ns_partner_odds <- function(country = 'US') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/partner-game/%s/now', country),
        type = 'w'
      )$games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
