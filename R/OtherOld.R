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

#' Get the glossary
#' 
#' `get_glossary()` is deprecated. Use [ns_glossary()] instead.
#' 
#' @export

get_glossary <- function() {
  .Deprecated(
    new     = 'ns_glossary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_teams()` is deprecated.',
      'Use `ns_glossary()` instead.'
    )
  )
  ns_glossary()
}

#' Get the configuration for skater, goalie, and team statistics
#' 
#' `get_configuration()` is deprecated. Use [ns_statistics_configuration()] instead.
#' 
#' @export

get_configuration <- function() {
  .Deprecated(
    new     = 'ns_statistics_configuration()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_configuration()` is deprecated.',
      'Use `ns_statistics_configuration()` instead.'
    )
  )
  ns_statistics_configuration()
}

#' Get all the countries
#' 
#' `get_countries()` is deprecated. Use [ns_countries()] instead.
#' 
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

#' Get all the venues
#' 
#' `get_venues()` is deprecated. Use [ns_venues()] instead.
#' 
#' @export

get_venues <- function() {
  .Deprecated(
    new     = 'ns_venues()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_venues()` is deprecated.',
      'Use `ns_venues()` instead.'
    )
  )
  ns_venues()
}

#' Get the attendance for all the seasons
#' 
#' `get_attendance()` is deprecated. Use [ns_attendance()] instead.
#' 
#' @export

get_attendance <- function() {
  .Deprecated(
    new     = 'ns_attendance()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_attendance()` is deprecated.',
      'Use `ns_attendance()` instead.'
    )
  )
  ns_attendance()
}

#' Get all the officials
#' 
#' `get_officials()` is deprecated. Use [ns_officials()] instead.
#' 
#' @export

get_officials <- function() {
  .Deprecated(
    new     = 'ns_officials()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_officials()` is deprecated.',
      'Use `ns_officials()` instead.'
    )
  )
  ns_officials()
}

#' Get all the streams
#' 
#' `get_streams()` is deprecated. Use [ns_streams()] instead.
#' 
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

#' Get the TV schedule of the NHL Network for a date
#' 
#' `get_tv_schedule()` is deprecated. Use [ns_tv_schedule()] instead.
#' 
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

#' Get partner odds as of now
#' 
#' `get_partner_odds()` is deprecated. Use [ns_partner_odds()] instead.
#' 
#' @export

get_partner_odds <- function(country = 'US') {
  .Deprecated(
    new     = 'ns_partner_odds()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_partner_odds()` is deprecated.',
      'Use `ns_partner_odds()` instead.'
    )
  )
  ns_partner_odds(country)
}
