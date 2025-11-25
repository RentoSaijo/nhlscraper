#' Access the glossary
#' 
#' `get_glossary()` is deprecated. Use [ns_glossary()] instead.
#' 
#' @returns data.frame with one row per terminology
#' @export

get_glossary <- function() {
  .Deprecated(
    new     = 'ns_glossary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_glossary()` is deprecated.',
      'Use `ns_glossary()` instead.'
    )
  )
  ns_glossary()
}

#' Access the configurations for skater, goalie, and team statistics reports
#' 
#' `get_configuration()` is deprecated. Use 
#' [ns_statistics_report_configuration()] instead.
#' 
#' @returns list with 5 items
#' @export

get_configuration <- function() {
  .Deprecated(
    new     = 'ns_statistics_report_configuration()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_configuration()` is deprecated.',
      'Use `ns_statistics_report_configuration()` instead.'
    )
  )
  ns_statistics_report_configuration()
}

#' Access all the countries
#' 
#' `get_countries()` is deprecated. Use [ns_countries()] instead.
#' 
#' @returns data.frame with one row per country
#' @export

get_countries <- function() {
  .Deprecated(
    new     = 'ns_countries()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_countries()` is deprecated.',
      'Use `ns_countries()` instead.'
    )
  )
  ns_countries()
}

#' Access all the streams
#' 
#' `get_streams()` is deprecated. Use [ns_streams()] instead.
#' 
#' @returns data.frame with one row per stream
#' @export

get_streams <- function() {
  .Deprecated(
    new     = 'ns_streams()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_streams()` is deprecated.',
      'Use `ns_streams()` instead.'
    )
  )
  ns_streams()
}

#' Access the NHL Network TV schedule for a date
#' 
#' `get_tv_schedule()` is deprecated. Use [ns_tv_schedule()] instead.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per program
#' @export

get_tv_schedule <- function(date = 'now') {
  .Deprecated(
    new     = 'ns_tv_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_tv_schedule()` is deprecated.',
      'Use `ns_tv_schedule()` instead.'
    )
  )
  ns_tv_schedule(date)
}

#' Get the real-time game odds for a country by partnered bookmaker
#' 
#' `get_partner_odds()` is deprecated. Use [ns_game_partner_odds()] instead.
#' 
#' @inheritParams ns_game_partner_odds
#' @returns data.frame with one row per game
#' @export

get_partner_odds <- function(country = 'US') {
  .Deprecated(
    new     = 'ns_game_partner_odds()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_partner_odds()` is deprecated.',
      'Use `ns_game_partner_odds()` instead.'
    )
  )
  ns_game_partner_odds(country)
}

#' Ping
#' 
#' `ping()` is defunct.
#' 
#' @export

ping <- function() {
  .Defunct(
    msg = paste(
      '`get_teams()` is defunct.'
    )
  )
}
