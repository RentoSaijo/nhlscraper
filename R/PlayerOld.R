#' Access all the players
#' 
#' `get_players()` is deprecated. Use [ns_players()] instead.
#' 
#' @returns data.frame with one row per player
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

#' Access the summary for a player
#' 
#' `get_player_landing()` is deprecated. Use [ns_player_summary()] instead.
#' 
#' @inheritParams ns_player_seasons
#' @returns list with various items
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

#' Access the game log for a player, season, and game type
#' 
#' `get_player_game_log()` is deprecated. Use [ns_player_game_log()] instead.
#' 
#' @inheritParams ns_player_seasons
#' @inheritParams ns_roster_statistics
#' @returns data.frame with one row per game
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

#' Access the spotlight players
#' 
#' `get_spotlight_players()` is deprecated. Use [ns_spotlight_players()] 
#' instead.
#' 
#' @returns data.frame with one row per player
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
