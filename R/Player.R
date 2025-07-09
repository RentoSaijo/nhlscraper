#' Get game-log by player, season, and game-type
#' 
#' @param player integer Player ID
#' @param season integer Season in YYYYYYYY
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @return tibble with one row per game
#' @examples
#' playoff_Mikko_Rantanen_gl_20242025 <- get_player_game_log(
#'   player=8478420,
#'   season=20242025,
#'   game_type=3
#' )
#' @export

get_player_game_log <- function(
    player=8480039,
    season=get_season_now()$seasonId,
    game_type=2
  ) {
  out <- nhl_api(
    path=sprintf('player/%s/game-log/%s/%s', player, season, game_type),
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out$gameLog))
}

#' Get landing by player
#' 
#' @param player integer Player ID
#' @return list with 36 items
#' @examples
#' Mikko_Rantanen_landing <- get_player_landing(player=8478420)
#' @export

get_player_landing <- function(player=8480039) {
  out <- nhl_api(
    path=sprintf('player/%s/landing', player),
    query=list(),
    type=1
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get 'spotlight' players as of now
#'
#' @return tibble with one row per player
#' @examples
#' spotlight_players_now <- get_spotlight_players()
#' @export

get_spotlight_players <- function() {
  out <- nhl_api(
    path='player-spotlight',
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out))
}
