#' Get a player's game log for a season
#' 
#' @param player_id integer NHL player ID
#' @param season string Season in 'YYYYYYYY' e.g. 20242025
#' @param game_type integer 2=regular, 3=playoffs
#' @return tibble with one row per game
#' @export

get_player_game_log <- function(player_id, season, game_type=2) {
  path <- sprintf('v1/player/%s/game-log/%s/%s', player_id, season, game_type)
  out <- req_nhl(path)
  return(tibble::as_tibble(out$gameLog))
}