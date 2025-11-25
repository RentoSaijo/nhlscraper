#' Access all the players
#' 
#' `get_players()` is deprecated. Use [players()] instead.
#' 
#' @returns data.frame with one row per player
#' @export

get_players <- function() {
  .Deprecated(
    new     = 'players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_players()` is deprecated.',
      'Use `players()` instead.'
    )
  )
  players()
}

#' Access the summary for a player
#' 
#' `get_player_landing()` is deprecated. Use [player_summary()] instead.
#' 
#' @inheritParams player_seasons
#' @returns list with various items
#' @export

get_player_landing <- function(player = 8478402) {
  .Deprecated(
    new     = 'player_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_player_landing()` is deprecated.',
      'Use `player_summary()` instead.'
    )
  )
  player_summary(player)
}

#' Access the game log for a player, season, and game type
#' 
#' `get_player_game_log()` is deprecated. Use [player_game_log()] instead.
#' 
#' @inheritParams player_seasons
#' @inheritParams roster_statistics
#' @returns data.frame with one row per game
#' @export

get_player_game_log <- function(
  player    = 8478402, 
  season    = 'now', 
  game_type = ''
) {
  .Deprecated(
    new     = 'player_game_log()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_player_game_log()` is deprecated.',
      'Use `player_game_log()` instead.'
    )
  )
  player_game_log(player, season, game_type)
}

#' Access the spotlight players
#' 
#' `get_spotlight_players()` is deprecated. Use [spotlight_players()] 
#' instead.
#' 
#' @returns data.frame with one row per player
#' @export

get_spotlight_players <- function() {
  .Deprecated(
    new     = 'spotlight_players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_spotlight_players()` is deprecated.',
      'Use `spotlight_players()` instead.'
    )
  )
  spotlight_players()
}
