#' Get score(s) by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per game
#' @export

get_scores <- function(date='2025-01-01') {
  out <- nhl_api(
    path=sprintf('score/%s', date),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$games))
}

#' Get scoreboard(s) by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per game
#' @export

get_scoreboards <- function(date='2025-01-01') {
  out <- nhl_api(
    path=sprintf('scoreboard/%s', date),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$gamesByDate[
    out$gamesByDate$date==date,
    ,
    drop=F
  ]
  $games[[1]]))
}

#' Get play-by-play by game
#' 
#' @param game_id integer Game ID
#' @return tibble with one row per play
#' @export

get_play_by_play <- function(game_id=2024020602) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/play-by-play', game_id),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$plays))
}

#' Get landing by game
#' 
#' @param game_id integer Game ID
#' @return list of 24 items
#' @export

get_game_landing <- function(game_id=2024020602) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/landing', game_id),
    query=list(),
    stats_rest=F
  )
  return(out)
}

#' Get boxscore by game, team, and player-type
#' 
#' @param game_id integer Game ID
#' @param team string Team whether 'home' or 'away'
#' @param player_type string Player-type of 'forwards', 'defensemen', or 'goalies'
#' @return tibble with one row per player
#' @export

get_game_boxscore <- function(
    game_id=2024020602,
    team='home',
    player_type='forwards'
  ) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/boxscore', game_id),
    query=list(),
    stats_rest=F
  )
  return(out$playerByGameStats[[paste0(team, 'Team')]][[player_type]])
}
