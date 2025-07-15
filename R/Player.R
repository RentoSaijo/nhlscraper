#' Get all players
#' 
#' `get_players()` retrieves information on each player, including but not limited to their ID, name, bio-metrics, birth date and location, and hall-of-fame status.
#'
#' @return tibble with one row per player
#' @examples
#' all_players <- get_players()
#' @export

get_players <- function() {
  out <- nhl_api(
    path='player',
    type=3
  )
  return(tibble::as_tibble(out$data))
}

#' Get game-log by player, season, and game-type
#' 
#' `get_player_game_log()` retrieves information on each game for a given set of `player`, `season`, and `game_type`, including but not limited to their ID, date, and statistics. Access `get_players()` for `player` and `get_seasons()` for `season` references.
#' 
#' @param player integer Player ID
#' @param season integer in YYYYYYYY
#' @param game_type integer where 2=regular and 3=playoffs
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
    type=1
  )
  return(tibble::as_tibble(out$gameLog))
}

#' Get landing by player
#' 
#' `get_player_landing()` retrieves information on a `player`, including but not limited to his ID, name, bio-metrics, career statistics, and awards. Access `get_players()` for `player` reference.
#' 
#' @param player integer Player ID
#' @return list with various items
#' @examples
#' Mikko_Rantanen_landing <- get_player_landing(player=8478420)
#' @export

get_player_landing <- function(player=8480039) {
  out <- nhl_api(
    path=sprintf('player/%s/landing', player),
    type=1
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get 'spotlight' players as of now
#' 
#' `get_spotlight_players()` retrieves information on each 'spotlight' player, including but not limited to their ID, name, position, and sweater number.
#'
#' @return tibble with one row per player
#' @examples
#' spotlight_players_now <- get_spotlight_players()
#' @export

get_spotlight_players <- function() {
  out <- nhl_api(
    path='player-spotlight',
    type=1
  )
  return(tibble::as_tibble(out))
}
