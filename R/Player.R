#' Get a player's game log for a season
#' 
#' @param player_id integer NHL player ID
#' @param season string Season in 'YYYYYYYY' e.g. 20242025
#' @param game_type integer 2=regular, 3=playoffs
#' @return tibble with one row per game
#' @export

get_player_game_log <- function(player_id, season=20242025, game_type=2) {
  out <- nhl_api(
    path=sprintf('player/%s/game-log/%s/%s', player_id, season, game_type),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$gameLog))
}

#' Get a player's information
#' 
#' @param player_id integer NHL player ID
#' @return list with 36 items
#' @export

get_player_information <- function(player_id) {
  out <- nhl_api(
    path=sprintf('player/%s/landing', player_id),
    query=list(),
    stats_rest=F
  )
  return(out)
}

#' Get 'spotlight' players
#'
#' @return tibble with one row per skater
#' @export

get_spotlight_players <- function() {
  out <- nhl_api(
    path='player-spotlight',
    query=list(),
    stats_rest=F
  )
  return(out)
}
