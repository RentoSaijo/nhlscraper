#' Get all teams
#' 
#' `get_teams()` retrieves information on each team, including but not limited to their ID, name, and 3-letter code.
#' 
#' @return tibble with one row per team
#' @examples
#' all_teams <- get_teams()
#' @export

get_teams <- function() {
  out <- nhl_api(
    path='team',
    query=list(limit=-1),
    type=2
  )
  return(tibble::as_tibble(out$data))
}

#' Get season(s) for which team played in regular season and/or playoffs
#' 
#' `get_team_seasons()` retrieves information on each season for a given `team`, including but not limited to their ID and game-type(s). Access `get_teams()` for `team` reference.
#' 
#' @param team 3-letter Code
#' @return tibble with one row per season
#' @examples
#' COL_seasons <- get_team_seasons(team='COL')
#' @export

get_team_seasons <- function(team='BOS') {
  out <- nhl_api(
    path=sprintf('club-stats-season/%s', team),
    type=1
  )
  if (length(out)==4) {
    return(tibble::tibble())
  }
  return(tibble::as_tibble(out))
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

#' Get roster by team, season, and player-type
#' 
#' `get_team_roster()` retrieves information on each player for a given set of `team`, `season`, and `player_type`, including but not limited to their ID, name, bio-metrics, and birth date and location. Access `get_teams()` for `team` and `get_team_seasons()` for `season` references.
#' 
#' @param team string 3-letter Code
#' @param season integer in YYYYYYYY
#' @param player_type string of 'forwards', 'defensemen', or 'goalies'
#' @return tibble with one row per player
#' @examples
#' COL_defensemen_20242025 <- get_team_roster(
#'   team='COL',
#'   season=20242025,
#'   player_type='defensemen'
#' )
#' @export

get_team_roster <- function(
    team='BOS',
    season=get_season_now()$seasonId,
    player_type='forwards'
) {
  out <- nhl_api(
    path=sprintf('roster/%s/%s', team, season),
    type=1
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get roster statistics by team, season, game-type, and player-type
#' 
#' `get_team_roster_statistics()` retrieves information on each player for a given set of `team`, `season`, `game_type` and `player_type`, including but not limited to their ID, name, and statistics. Access `get_teams()` for `team` and `get_team_seasons()` for `season` references.
#' 
#' @param team string 3-letter Code
#' @param season integer in YYYYYYYY
#' @param game_type integer where 2=regular and 3=playoffs
#' @param player_type string of 'skaters' or 'goalies'
#' @return tibble with one row per player
#' @examples
#' regular_COL_goalies_statistics_20242025 <- get_team_roster_statistics(
#'   team='COL',
#'   season=20242025,
#'   game_type=2,
#'   player_type='goalies'
#' )
#' @export

get_team_roster_statistics <- function(
    team='BOS',
    season=get_season_now()$seasonId,
    game_type=2,
    player_type='skaters'
) {
  out <- nhl_api(
    path=sprintf('club-stats/%s/%s/%s', team, season, game_type),
    type=1
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get prospects by team and player-type
#' 
#' `get_team_prospects()` retrieves information on each prospect for a given set of `team` and `player_type`, including but not limited to their ID, name, bio-metrics, and birth date and location. Access `get_teams()` for `team` reference.
#' 
#' @param team string 3-letter Code
#' @param player_type string of 'forwards', 'defensemen', or 'goalies'
#' @return tibble with one row per player
#' @examples
#' COL_defensemen_prospects <- get_team_prospects(
#'   team='COL',
#'   player_type='defensemen'
#' )
#' @export

get_team_prospects <- function(team='BOS', player_type='forwards') {
  out <- nhl_api(
    path=sprintf('prospects/%s', team),
    type=1
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get schedule by team and season
#' 
#' `get_team_schedule()` retrieves information on each game for a given set of `team` and `season`, including but not limited to their ID, season, type, start date and time, and home and visiting teams' IDs and scores. Access `get_teams()` for `team` and `get_team_seasons()` for `season` references.
#' 
#' @param team string 3-letter Code
#' @param season integer in YYYYYYYY
#' @return tibble with one row per game
#' @examples
#' COL_schedule_20242025 <- get_team_schedule(team='COL', season=20242025)
#' @export

get_team_schedule <- function(team='BOS', season=get_season_now()$seasonId) {
  out <- nhl_api(
    path=sprintf('club-schedule-season/%s/%s', team, season),
    type=1
  )
  return(tibble::as_tibble(out$games))
}

#' Get team scoreboard as of now
#' 
#' `get_team_scoreboard()` retrieves information on the current game for a given `team`, including but not limited to their ID, season, type, start date and time, and home and visiting teams' IDs and scores. Access `get_teams()` for `team` reference.
#' 
#' @param team string 3-letter Code
#' @return tibble with one row per game
#' @examples
#' FLA_scoreboard_now <- get_team_scoreboard(team='FLA')
#' @export

get_team_scoreboard <- function(team='BOS') {
  out <- nhl_api(
    path=sprintf('scoreboard/%s/now', team),
    type=1
  )
  if (is.null(out$gamesByDate)) {
    return(tibble::tibble())
  }
  sub <- out$gamesByDate[out$gamesByDate$date==out$focusedDate, , drop=FALSE]
  if (nrow(sub)==0) {
    return(tibble::tibble())
  }
  tibble::as_tibble(sub$games[[1]])
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
