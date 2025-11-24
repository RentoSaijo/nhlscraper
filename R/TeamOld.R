#' Get all the teams
#' 
#' `get_teams()` is deprecated. Use [ns_teams()] instead.
#' 
#' @return data.frame with one row per team
#' @export

get_teams <- function() {
  .Deprecated(
    new     = 'ns_teams()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_teams()` is deprecated.',
      'Use `ns_teams()` instead.'
    )
  )
  ns_teams()
}

#' Get the season(s) and game type(s) in which a team played
#' 
#' `get_team_seasons()` is deprecated. Use [ns_team_seasons()] instead.
#' 
#' @param team three-letter code (e.g., 'COL')
#' @return data.frame with one row per season
#' @export

get_team_seasons <- function(team = 'NJD') {
  .Deprecated(
    new     = 'ns_team_seasons()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_seasons()` is deprecated.',
      'Use `ns_team_seasons()` instead.'
    )
  )
  ns_team_seasons(team)
}

#' Get the roster for a team, season, and player type
#' 
#' `get_team_roster()` is deprecated. Use [ns_roster()] instead.
#' 
#' @param team three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param player_type character of 'forwards', 'defensemen', or 'goalies'
#' @return data.frame with one row per player
#' @export

get_team_roster <- function(
    team        = 'NJD',
    season      = 'current',
    player_type = 'forwards'
) {
  .Deprecated(
    new     = 'ns_roster()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_roster()` is deprecated.',
      'Use `ns_roster()` instead.'
    )
  )
  ns_roster(team, season, player_type)
}

#' Get the roster statistics for a team, season, game type, and player type
#' 
#' `get_team_roster_statistics()` is deprecated. Use [ns_roster_statistics()] 
#' instead.
#' 
#' @param team three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param player_type character of 'skaters' or 'goalies'
#' @return data.frame with one row per player
#' @export

get_team_roster_statistics <- function(
    team        = 'NJD',
    season      = 'now',
    game_type   = 2,
    player_type = 'skaters'
) {
  .Deprecated(
    new     = 'ns_roster_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_roster_statistics()` is deprecated.',
      'Use `ns_roster_statistics()` instead.'
    )
  )
  ns_roster_statistics(team, season, game_type, player_type)
}

#' Get the prospects for a team and player type
#' 
#' `get_team_prospects()` is deprecated. Use [ns_team_prospects()] instead.
#' 
#' @param team three-letter code (e.g., 'COL')
#' @param player_type character of 'forwards', 'defensemen', or 'goalies'
#' @return data.frame with one row per player
#' @export

get_team_prospects <- function(team = 'NJD', player_type = 'forwards') {
  .Deprecated(
    new     = 'ns_team_prospects()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_prospects()` is deprecated.',
      'Use `ns_team_prospects()` instead.'
    )
  )
  ns_team_prospects(team, player_type)
}

#' Get the schedule for a team and season
#' 
#' `get_team_schedule()` is deprecated. Use [ns_team_season_schedule()] instead.
#' 
#' @param team three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @return data.frame with one row per game
#' @export

get_team_schedule <- function(team = 'NJD', season = 'now') {
  .Deprecated(
    new     = 'ns_team_season_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_schedule()` is deprecated.',
      'Use `ns_team_season_schedule()` instead.'
    )
  )
  ns_team_season_schedule(team, season)
}

#' Get various reports for all the teams by season or game
#' 
#' `get_team_statistics()` is defunct. Use [ns_team_season_report()] or 
#' [ns_team_game_report()] instead.
#' 
#' @export

get_team_statistics <- function(
    season       = 20242025,
    report       = 'summary',
    is_aggregate = FALSE,
    is_game      = FALSE,
    dates        = c('2025-01-01'),
    game_types   = 1:3
) {
  .Defunct(
    new     = 'ns_team_season_report()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_statistics()` is defunct.',
      'Use `ns_team_season_report()` or `ns_team_game_report` instead.'
    )
  )
}

#' Get team scoreboard as of now
#' 
#' `get_team_scoreboard()` is defunct.
#' 
#' @export

get_team_scoreboard <- function(team = 'NJD') {
  .Defunct(
    msg = paste(
      '`get_team_scoreboard()` is defunct.'
    )
  )
}
