#' Get all the players
#' 
#' `get_players()` is deprecated. Use [ns_players()] instead.
#' 
#' @return data.frame with one row per player
#' @export

get_players <- function() {
  .Deprecated(
    new     = 'ns_players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_players()` is deprecated.',
      'Use `ns_players()` instead.'
    )
  )
  ns_players()
}

#' Get the summary for a player
#' 
#' `get_player_landing()` is deprecated. Use [ns_player_summary()] instead.
#' 
#' @param player integer ID (e.g., 8480039)
#' @return list with various items
#' @export

get_player_landing <- function(player = 8478402) {
  .Deprecated(
    new     = 'ns_player_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_player_landing()` is deprecated.',
      'Use `ns_player_summary()` instead.'
    )
  )
  ns_player_summary(player)
}

#' Get the game log for a player, season, and game type
#' 
#' `get_player_game_log()` is deprecated. Use [ns_player_game_log()] instead.
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return data.frame with one row per game
#' @export

get_player_game_log <- function(
  player    = 8478402, 
  season    = 'now', 
  game_type = ''
) {
  .Deprecated(
    new     = 'ns_player_game_log()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_player_game_log()` is deprecated.',
      'Use `ns_player_game_log()` instead.'
    )
  )
  ns_player_game_log(player, season, game_type)
}

#' Get the spotlight players
#' 
#' `get_spotlight_players()` is deprecated. Use [ns_spotlight_players()] 
#' instead.
#' 
#' @return data.frame with one row per player
#' @export

get_spotlight_players <- function() {
  .Deprecated(
    new     = 'ns_spotlight_players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_spotlight_players()` is deprecated.',
      'Use `ns_spotlight_players()` instead.'
    )
  )
  ns_spotlight_players()
}
