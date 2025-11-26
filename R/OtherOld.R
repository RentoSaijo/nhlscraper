#' Access the glossary
#' 
#' `get_glossary()` is deprecated. Use [glossary()] instead.
#' 
#' @returns data.frame with one row per terminology
#' @export

get_glossary <- function() {
  .Deprecated(
    new     = 'glossary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_glossary()` is deprecated.',
      'Use `glossary()` instead.'
    )
  )
  glossary()
}

#' Access all the countries
#' 
#' `get_countries()` is deprecated. Use [countries()] instead.
#' 
#' @returns data.frame with one row per country
#' @export

get_countries <- function() {
  .Deprecated(
    new     = 'countries()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_countries()` is deprecated.',
      'Use `countries()` instead.'
    )
  )
  countries()
}

#' Access all the streams
#' 
#' `get_streams()` is deprecated. Use [streams()] instead.
#' 
#' @returns data.frame with one row per stream
#' @export

get_streams <- function() {
  .Deprecated(
    new     = 'streams()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_streams()` is deprecated.',
      'Use `streams()` instead.'
    )
  )
  streams()
}

#' Access the NHL Network TV schedule for a date
#' 
#' `get_tv_schedule()` is deprecated. Use [tv_schedule()] instead.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per program
#' @export

get_tv_schedule <- function(date = 'now') {
  .Deprecated(
    new     = 'tv_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_tv_schedule()` is deprecated.',
      'Use `tv_schedule()` instead.'
    )
  )
  tv_schedule(date)
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

#' Access the configurations for team, skater, and goalie reports
#' 
#' `get_configuration()` is defunct. Use [team_report_configurations()], 
#' [skater_report_configurations()], and/or [goalie_report_configurations()] 
#' instead.
#' 
#' @export

get_configuration <- function() {
  .Defunct(
    new     = 'team_report_configurations()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_configuration()` is defunct.',
      'Use `team_report_configurations()`, `skater_report_configurations()`,',
      'and/or `goalie_report_configurations()` instead.'
    )
  )
}

