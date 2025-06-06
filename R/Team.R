#' Get season(s) for which team played in regular season and/or playoffs
#' 
#' @param team string 3-letter team code
#' @return tibble with one row per season
#' @examples
#' COL_seasons <- get_team_seasons(team='COL')
#' @export

get_team_seasons <- function(team='BOS') {
  out <- nhl_api(
    path=sprintf('club-stats-season/%s', team),
    query=list(),
    stats_rest=FALSE
  )
  if (length(out)==4) {
    return(tibble::tibble())
  }
  return(tibble::as_tibble(out))
}

#' Get roster statistics by team, season, game-type, and player-type
#' 
#' @param team string 3-letter team code
#' @param season integer Season in YYYYYYYY
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @param player_type string Player-type of 'skaters' or 'goalies'
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
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get team scoreboard as of now
#' 
#' @param team string 3-letter team code
#' @return tibble with one row per game
#' @examples
#' FLA_scoreboard_now <- get_team_scoreboard(team='FLA')
#' @export

get_team_scoreboard <- function(team='BOS') {
  out <- nhl_api(
    path=sprintf('scoreboard/%s/now', team),
    query=list(),
    stats_rest=FALSE
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

#' Get roster by team, season, and player-type
#' 
#' @param team string 3-letter team code
#' @param season integer Season in YYYYYYYY
#' @param player_type string Player-type of 'forwards', 'defensemen', or
#'                    'goalies'
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
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get prospects by team and player-type
#' 
#' @param team string 3-letter team code
#' @param player_type string Player-type of 'forwards', 'defensemen', or
#'                    'goalies'
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
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get schedule by team and season
#' 
#' @param team string 3-letter team code
#' @param season integer Season in YYYYYYYY
#' @return tibble with one row per game
#' @examples
#' COL_schedule_20242025 <- get_team_schedule(team='COL', season=20242025)
#' @export

get_team_schedule <- function(team='BOS', season=get_season_now()$seasonId) {
  out <- nhl_api(
    path=sprintf('club-schedule-season/%s/%s', team, season),
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out$games))
}

#' Get all teams
#' 
#' @return tibble with one row per team
#' @examples
#' all_teams <- get_teams()
#' @export

get_teams <- function() {
  out <- nhl_api(
    path='team',
    query=list(limit=-1),
    stats_rest=TRUE
  )
  return(tibble::as_tibble(out$data))
}

#' Get all franchises
#' 
#' @return tibble with one row per franchise
#' @examples
#' all_franchises <- get_franchises()
#' @export

get_franchises <- function() {
  out <- nhl_api(
    path='franchise',
    query=list(limit=-1),
    stats_rest=TRUE
  )
  return(tibble::as_tibble(out$data))
}

#' Get team statistics by season
#' 
#' @param season integer Season in YYYYYYYY
#' @param report string Report (check `get_configuration()` for possible inputs)
#' @param is_aggregate boolean isAggregate where TRUE=regular and playoffs
#'                     combined, if applicable
#' @param is_game boolean isGame where TRUE=rows by games and FALSE=rows by
#'                teams
#' @param dates vector of strings Date(s) in 'YYYY-MM-DD' (only if paired with
#'              `is_game`; too many dates will result in incomplete data)
#' @param game_types vector of integers Game-type(s) where 1=pre-season,
#'                   2=regular, and 3=playoffs
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
      stats_rest=TRUE
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
      stats_rest=TRUE
    )
  }
  return(tibble::as_tibble(out$data))
}
