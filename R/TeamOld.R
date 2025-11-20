#' Get all the teams
#' 
#' `get_teams()` is deprecated. Use [ns_teams()] instead.
#' 
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

#' Get the season(s) and game type(s) of which a team played in
#' 
#' `get_team_seasons()` is deprecated. Use [ns_team_seasons()] instead.
#' 
#' @export

get_team_seasons <- function(team = 1) {
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

#' Get team statistics
#' 
#' `get_team_statistics()` is defunct. Use [ns_team_statistics()] instead.
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
    new     = 'ns_team_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_statistics()` is defunct',
      'Use `ns_team_statistics()` instead.'
    )
  )
}

#' Get the roster of a team for a season and position
#' 
#' `get_team_roster()` is deprecated. Use [ns_roster()] instead.
#' 
#' @export

get_team_roster <- function(
    team        = 1,
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

#' Get the statistics of a roster for a season, game type, and position
#' 
#' `get_team_roster_statistics()` is deprecated. Use [ns_roster_statistics()] 
#' instead.
#' 
#' @export

get_team_roster_statistics <- function(
    team        = 1,
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

#' Get the prospects of a team for a position
#' 
#' `get_team_prospects()` is deprecated. Use [ns_team_prospects()] instead.
#' 
#' @export

get_team_prospects <- function(team = 1, player_type = 'forwards') {
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

#' Get the schedule of a team for a season
#' 
#' `get_team_schedule()` is deprecated. Use [ns_team_schedule_season()] instead.
#' 
#' @export

get_team_schedule <- function(team = 1, season = 'now') {
  .Deprecated(
    new     = 'ns_team_schedule_season()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_schedule()` is deprecated.',
      'Use `ns_team_schedule_season()` instead.'
    )
  )
  ns_team_schedule_season(team, season)
}

#' Get team scoreboard as of now
#' 
#' `get_team_scoreboard()` is defunct.
#' 
#' @export

get_team_scoreboard <- function(team = 1) {
  .Defunct(
    msg = paste(
      '`get_team_scoreboard()` is defunct.'
    )
  )
}
