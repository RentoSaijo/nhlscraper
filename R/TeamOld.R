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
#' `get_team_statistics()` retrieves information on each team or game for a given set of `season`, `game_types`, and `report`. `dates` must be given when paired with `is_game` as the default range will return incomplete data (too wide).  Access `get_configuration()` for what information each combination of `report`, `is_aggregate` and `is_game` can provide. Access `get_team_seasons()` for `season` and `dates` references. Will soon be reworked for easier access.
#' 
#' @param season integer in YYYYYYYY
#' @param game_types vector of integers where 1=pre-season, 2=regular, and 
#'                   3=playoffs
#' @param dates vector of strings in 'YYYY-MM-DD'
#' @param report string
#' @param is_aggregate boolean
#' @param is_game boolean
#' @return tibble with one row per team or game
#' @examples
#' playoff_team_stf_20242025 <- get_team_statistics(
#'   season=20242025,
#'   report='scoretrailfirst',
#'   game_types=c(3)
#' )
#' 
#' @export

get_team_statistics <- function(
    season=get_season_now()$seasonId,
    report='summary',
    is_aggregate=FALSE,
    is_game=FALSE,
    dates=c('2025-01-01'),
    game_types=1:3
) {
  if (is_game) {
    for (date in dates) {
      if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
        stop('date in `dates` must be in \'YYYY-MM-DD\' format', call.=FALSE)
      }
    }
    out <- nhl_api(
      path=sprintf('team/%s', report),
      query=list(
        limit=-1,
        isGame=TRUE,
        isAggregate=is_aggregate,
        cayenneExp=sprintf(
          'seasonId=%s and gameDate in (%s) and gameTypeId in (%s)',
          season,
          paste0('\'', dates, '\'', collapse=','),
          paste(game_types, collapse=',')
        )
      ),
      type=2
    )
  }
  else {
    out <- nhl_api(
      path=sprintf('team/%s', report),
      query=list(
        limit=-1,
        isAggregate=is_aggregate,
        cayenneExp=sprintf(
          'seasonId=%s and gameTypeId in (%s)',
          season,
          paste(game_types, collapse=',')
        )
      ),
      type=2
    )
  }
  return(tibble::as_tibble(out$data))
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

#' Get all franchises
#' 
#' `get_franchises()` retrieves information on each franchise, including but not limited to their ID; first and last seasons' IDs; captain, coach, and general manager histories; and retired numbers.
#' 
#' @importFrom magrittr %>%
#' @return tibble with one row per franchise
#' @examples
#' all_franchises <- get_franchises()
#' @export

get_franchises <- function() {
  out <- nhl_api(
    path='franchise',
    type=3
  )
  out <- out$data %>% 
    dplyr::select(-firstSeasonId, -mostRecentTeamId, -teamAbbrev)
  out2 <- nhl_api(
    path='franchise-detail',
    type=3
  )
  merged <- out2$data %>% 
    dplyr::left_join(out, by='id')
  return(tibble::as_tibble(merged))
}

#' Get all franchises' season-by-season results
#' 
#' `get_franchise_season_by_season()` retrieves information on each franchise's season, including but not limited to their ID, decision, final playoff round, and statistics.
#' 
#' @return tibble with one row per franchise's season
#' @examples
#' all_franchise_sbs <- get_franchise_season_by_season()
#' @export

get_franchise_season_by_season <- function() {
  out <- nhl_api(
    path='franchise-season-results',
    type=3
  )
  return(tibble::as_tibble(out$data))
}
