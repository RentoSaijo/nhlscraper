#' Access all the seasons
#' 
#' `get_seasons()` is deprecated. Use [seasons()] instead.
#' 
#' @returns data.frame with one row per season
#' @export

get_seasons <- function() {
  .Deprecated(
    new     = 'seasons()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_seasons()` is deprecated.',
      'Use `seasons()` instead.'
    )
  )
  seasons()
}

#' Access the season and game type as of now
#' 
#' `get_season_now()` is defunct. Use [season_now()] and/or [game_type()] 
#' instead.
#' 
#' @export

get_season_now <- function() {
  .Defunct(
    new     = 'season_now()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_season_now()` is defunct.',
      'Use `season_now()` and/or `game_type()` instead.'
    )
  )
}

#' Access the standings rules by season
#' 
#' `get_standings_information()` is deprecated. Use [standings_rules()] 
#' instead.
#' 
#' @returns data.frame with one row per season
#' @export

get_standings_information <- function() {
  .Deprecated(
    new     = 'standings_rules()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_standings_information()` is deprecated.',
      'Use `standings_rules()` instead.'
    )
  )
  standings_rules()
}

#' Access the standings for a date
#' 
#' `get_standings()` is deprecated. Use [standings()] instead.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per team
#' @export

get_standings <- function(date = '2025-01-01') {
  .Deprecated(
    new     = 'standings()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_standings()` is deprecated.',
      'Use `standings()` instead.'
    )
  )
  standings(date)
}

#' Access the schedule for a date
#' 
#' `get_schedule()` is deprecated. Use [schedule()] instead.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @export

get_schedule <- function(date = '2025-01-01') {
  .Deprecated(
    new     = 'schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_schedule()` is deprecated.',
      'Use `schedule()` instead.'
    )
  )
  schedule(date)
}

#' Access all the venues
#' 
#' `get_venues()` is deprecated. Use [venues()] instead.
#' 
#' @returns data.frame with one row per venue
#' @export

get_venues <- function() {
  .Deprecated(
    new     = 'venues()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_venues()` is deprecated.',
      'Use `venues()` instead.'
    )
  )
  venues()
}

#' Access the attendance by season and game type
#' 
#' `get_attendance()` is deprecated. Use [attendance()] instead.
#' 
#' @returns data.frame with one row per season
#' @export

get_attendance <- function() {
  .Deprecated(
    new     = 'attendance()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_attendance()` is deprecated.',
      'Use `attendance()` instead.'
    )
  )
  attendance()
}
