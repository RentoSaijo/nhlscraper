#' Get which year(s) a team played in regular season and/or playoffs
#' 
#' @param team string Team in 3-letter code
#' @return tibble with one row per season
#' @export

get_team_seasons <- function(team='BOS') {
  out <- nhl_api(
    path=sprintf('club-stats-season/%s', team),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out))
}

#' Get team statistics by season, game-type, and player-type
#' 
#' @param team string Team in 3-letter code
#' @param season integer Season in YYYYYYYY
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @param player_type string Player-type of 'skaters' or 'goalies'
#' @return tibble with one row per player
#' @export

get_team_statistics <- function(
    team='BOS',
    season=20242025,
    game_type=2,
    player_type='skaters'
  ) {
  out <- nhl_api(
    path=sprintf('club-stats/%s/%s/%s', team, season, game_type),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get team scoreboard now
#' 
#' @param team string Team in 3-letter code
#' @return ???
#' @export

get_team_scoreboard <- function(team='BOS') {
  out <- nhl_api(
    path=sprintf('scoreboard/%s/now', team),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$gamesByDate[
    out$gamesByDate$date==out$focusedDate,
    ,
    drop=F
  ]
  $games[[1]]))
}

#' Get team roster by season and player-type.
#' 
#' @param team string Team in 3-letter code
#' @param season integer Season in YYYYYYYY
#' @param player_type string Player-type of 'forwards', 'defensemen', or 'goalies'
#' @return tibble with one row per player
#' @export

get_team_roster <- function(
    team='BOS',
    season=20242025,
    player_type='forwards'
  ) {
  out <- nhl_api(
    path=sprintf('roster/%s/%s', team, season),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get team prospects by player-type
#' 
#' @param team string Team in 3-letter code
#' @param player_type string Player-type of 'forwards', 'defensemen', or 'goalies'
#' @return tibble with one row per player
#' @export

get_team_prospects <- function(team='BOS', player_type='forwards') {
  out <- nhl_api(
    path=sprintf('prospects/%s', team),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out[[player_type]]))
}

#' Get team schedule by season
#' 
#' @param team string Team in 3-letter code
#' @param season integer Season in YYYYYYYY
#' @return tibble with one row per game
#' @export

get_team_schedule <- function(team='BOS', season=20242025) {
  out <- nhl_api(
    path=sprintf('club-schedule-season/%s/%s', team, season),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$games))
}
