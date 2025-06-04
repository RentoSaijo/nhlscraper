#' Get a player's game log for a season
#' 
#' @param player_id integer Player ID
#' @param season integer Season in YYYYYYYY
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @return tibble with one row per game
#' @export

get_player_game_log <- function(
    player_id=8480039,
    season=get_season_now()$seasonId,
    game_type=2
  ) {
  out <- nhl_api(
    path=sprintf('player/%s/game-log/%s/%s', player_id, season, game_type),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$gameLog))
}

#' Get a player's landing
#' 
#' @param player_id integer Player ID
#' @return list with 36 items
#' @export

get_player_landing <- function(player_id=8480039) {
  out <- nhl_api(
    path=sprintf('player/%s/landing', player_id),
    query=list(),
    stats_rest=F
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get 'spotlight' players
#'
#' @return tibble with one row per player
#' @export

get_spotlight_players <- function() {
  out <- nhl_api(
    path='player-spotlight',
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out))
}
