#' Access the glossary
#' 
#' `glossary()` scrapes the glossary.
#' 
#' @returns data.frame with one row per terminology
#' @examples
#' glossary <- glossary()
#' @export

glossary <- function() {
  nhl_api(
    path = 'en/glossary',
    type = 's'
  )$data
}

#' Access the configurations for skater, goalie, and team statistics reports
#' 
#' `statistics_report_configurations()` scrapes the configurations for 
#' [team_season_report()], [team_game_report()], 
#' [skater_season_report()], [skater_game_report()], 
#' [goalie_season_report()], and [goalie_game_report()].
#' 
#' @returns list with 5 items
#' @examples
#' stats_report_config <- statistics_report_configurations()
#' @export

statistics_report_configurations <- function() {
  nhl_api(
    path = 'en/config',
    type = 's'
  )
}

#' @rdname statistics_report_configurations
#' @export
stats_report_configs <- function() {
  statistics_report_configurations()
}

#' Access all the countries
#' 
#' `countries` scrapes information on all the countries.
#' 
#' @returns data.frame with one row per country
#' @examples
#' all_countries <- countries()
#' @export

countries <- function() {
  nhl_api(
    path = 'en/country',
    type = 's'
  )$data
}

#' Access the location for a zip code
#' 
#' `location()` scrapes the location for a given `zip` code.
#' 
#' @param zip integer (e.g., 48304)
#' @returns data.frame with one row per team
#' @examples
#' Cranbrook_Schools <- location(48304)
#' @export

location <- function(zip = 10001) {
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
#' `streams()` scrapes information on all the streams.
#' 
#' @returns data.frame with one row per stream
#' @examples
#' all_streams <- streams()
#' @export

streams <- function() {
  nhl_api(
    path = 'v1/where-to-watch',
    type = 'w'
  )
}

#' Access the NHL Network TV schedule for a date
#' 
#' `tv_schedule()` scrapes the NHL Network TV schedule for a given `date`
#' 
#' @inheritParams standings
#' @returns data.frame with one row per program
#' @examples
#' tv_schedule_Halloween_2025 <- tv_schedule(date = '2025-10-31')
#' @export

tv_schedule <- function(date = 'now') {
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
#' `game_partner_odds()` scrapes the real-time game odds for a given 
#' `country` by partnered bookmaker.
#' 
#' @param country two-letter code (e.g., 'CA'); see [countries()] for 
#' reference
#' @returns data.frame with one row per game
#' @examples
#' game_partner_odds_CA <- game_partner_odds(country = 'CA')
#' @export

game_partner_odds <- function(country = 'US') {
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
