#' Access all the seasons
#' 
#' `get_seasons()` is deprecated. Use [ns_seasons()] instead.
#' 
#' @returns data.frame with one row per season
#' @export

get_seasons <- function() {
  .Deprecated(
    new     = 'ns_seasons()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_seasons()` is deprecated.',
      'Use `ns_seasons()` instead.'
    )
  )
  ns_seasons()
}

#' Access the season and game type as of now
#' 
#' `get_season_now()` is defunct. Use [ns_season()] and/or [ns_game_type()] 
#' instead.
#' 
#' @export

get_season_now <- function() {
  .Defunct(
    new     = 'ns_season()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_season_now()` is defunct.',
      'Use `ns_season()` and/or `ns_game_type()` instead.'
    )
  )
}

#' Access the standings rules by season
#' 
#' `get_standings_information()` is deprecated. Use [ns_standings_rules()] 
#' instead.
#' 
#' @returns data.frame with one row per season
#' @export

get_standings_information <- function() {
  .Deprecated(
    new     = 'ns_standings_rules()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_standings_information()` is deprecated.',
      'Use `ns_standings_rules()` instead.'
    )
  )
  ns_standings_rules()
}

#' Access the standings for a date
#' 
#' `get_standings()` is deprecated. Use [ns_standings()] instead.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per team
#' @export

get_standings <- function(date = '2025-01-01') {
  .Deprecated(
    new     = 'ns_standings()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_standings()` is deprecated.',
      'Use `ns_standings()` instead.'
    )
  )
  ns_standings(date)
}

#' Access the schedule for a date
#' 
#' `get_schedule()` is deprecated. Use [ns_schedule()] instead.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per game
#' @export

get_schedule <- function(date = '2025-01-01') {
  .Deprecated(
    new     = 'ns_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_schedule()` is deprecated.',
      'Use `ns_schedule()` instead.'
    )
  )
  ns_schedule(date)
}

#' Access the attendance by season and game type
#' 
#' `get_attendance()` is deprecated. Use [ns_attendance()] instead.
#' 
#' @returns data.frame with one row per season
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
