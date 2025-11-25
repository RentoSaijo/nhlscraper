#' Access the glossary
#' 
#' `ns_glossary()` scrapes the glossary.
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

#' Access the configurations for skater, goalie, and team statistics reports
#' 
#' `ns_statistics_report_configuration()` scrapes the configurations for 
#' [ns_team_season_report()], [ns_team_game_report()], 
#' [ns_skater_season_report()], [ns_skater_game_report()], 
#' [ns_goalie_season_report()], and [ns_goalie_game_report()].
#' 
#' @returns list with 5 items
#' @examples
#' stats_report_config <- ns_statistics_report_configuration()
#' @export

ns_statistics_report_configuration <- function() {
  nhl_api(
    path = 'en/config',
    type = 's'
  )
}

#' @rdname ns_statistics_report_configuration
#' @export
ns_stats_report_config <- function() {
  ns_statistics_report_configuration()
}

#' Access all the countries
#' 
#' `ns_countries` scrapes information on all the countries.
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

#' Access the location for a zip code
#' 
#' `ns_location()` scrapes the location for a given `zip` code.
#' 
#' @param zip integer (e.g., 48304)
#' @returns data.frame with one row per team
#' @examples
#' Cranbrook_Schools <- ns_location(48304)
#' @export

ns_location <- function(zip = 10001) {
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

#' Access all the streams
#' 
#' `ns_streams()` scrapes information on all the streams.
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

#' Access the NHL Network TV schedule for a date
#' 
#' `ns_tv_schedule()` scrapes the NHL Network TV schedule for a given `date`
#' 
#' @inheritParams ns_standings
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

#' Get the real-time game odds for a country by partnered bookmaker
#' 
#' `ns_game_partner_odds()` scrapes the real-time game odds for a given 
#' `country` by partnered bookmaker.
#' 
#' @param country two-letter code (e.g., 'CA'); see [ns_countries()] for 
#' reference
#' @returns data.frame with one row per game
#' @examples
#' game_partner_odds_CA <- ns_game_partner_odds(country = 'CA')
#' @export

ns_game_partner_odds <- function(country = 'US') {
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
