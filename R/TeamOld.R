#' Access all the teams
#' 
#' `get_teams()` is deprecated. Use [teams()] instead.
#' 
#' @returns data.frame with one row per team
#' @export

get_teams <- function() {
  .Deprecated(
    new     = 'teams()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_teams()` is deprecated.',
      'Use `teams()` instead.'
    )
  )
  teams()
}

#' Access the season(s) and game type(s) in which a team played
#' 
#' `get_team_seasons()` is deprecated. Use [team_seasons()] instead.
#' 
#' @param team three-letter code (e.g., 'COL'); see [teams()] for reference
#' @returns data.frame with one row per season
#' @export

get_team_seasons <- function(team = 'NJD') {
  .Deprecated(
    new     = 'team_seasons()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_seasons()` is deprecated.',
      'Use `team_seasons()` instead.'
    )
  )
  team_seasons(team)
}

#' Access the roster for a team, season, and player type
#' 
#' `get_team_roster()` is deprecated. Use [roster()] instead.
#' 
#' @inheritParams get_team_seasons
#' @param season integer in YYYYYYYY (e.g., 20242025); see [seasons()] for 
#' reference
#' @param player_type character of 'forwards', 'defensemen', or 'goalies'
#' @returns data.frame with one row per player
#' @export

get_team_roster <- function(
  team        = 'NJD',
  season      = 'current',
  player_type = 'forwards'
) {
  .Deprecated(
    new     = 'roster()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_roster()` is deprecated.',
      'Use `roster()` instead.'
    )
  )
  roster(team, season, player_type)
}

#' Access the roster statistics for a team, season, game type, and player type
#' 
#' `get_team_roster_statistics()` is deprecated. Use [roster_statistics()] 
#' instead.
#' 
#' @inheritParams get_team_roster
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 
#' playoff'/'post'; see [seasons()] for reference
#' @param player_type character of 'skaters' or 'goalies'
#' @returns data.frame with one row per player
#' @export

get_team_roster_statistics <- function(
  team        = 'NJD',
  season      = 'now',
  game_type   = 2,
  player_type = 'skaters'
) {
  .Deprecated(
    new     = 'roster_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_roster_statistics()` is deprecated.',
      'Use `roster_statistics()` instead.'
    )
  )
  roster_statistics(team, season, game_type, player_type)
}

#' Access the prospects for a team and position
#' 
#' `get_team_prospects()` is deprecated. Use [team_prospects()] instead.
#' 
#' @inheritParams get_team_roster
#' @returns data.frame with one row per player
#' @export

get_team_prospects <- function(team = 'NJD', player_type = 'forwards') {
  .Deprecated(
    new     = 'team_prospects()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_prospects()` is deprecated.',
      'Use `team_prospects()` instead.'
    )
  )
  team_prospects(team, player_type)
}

#' Access the schedule for a team and season
#' 
#' `get_team_schedule()` is deprecated. Use [team_season_schedule()] instead.
#' 
#' @inheritParams get_team_roster
#' @returns data.frame with one row per game
#' @export

get_team_schedule <- function(team = 'NJD', season = 'now') {
  .Deprecated(
    new     = 'team_season_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_schedule()` is deprecated.',
      'Use `team_season_schedule()` instead.'
    )
  )
  team_season_schedule(team, season)
}

#' Access various reports for all the teams by season or game
#' 
#' `get_team_statistics()` is defunct. Use [team_season_report()] or 
#' [team_game_report()] instead.
#' 
#' @export

get_team_statistics <- function() {
  .Defunct(
    new     = 'team_season_report()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_team_statistics()` is defunct.',
      'Use `team_season_report()` or `team_game_report` instead.'
    )
  )
}

#' Access the team scoreboard as of now
#' 
#' `get_team_scoreboard()` is defunct.
#' 
#' @export

get_team_scoreboard <- function() {
  .Defunct(
    msg = paste(
      '`get_team_scoreboard()` is defunct.'
    )
  )
}
