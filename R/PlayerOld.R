#' Get all the players
#' 
#' `get_players()` is deprecated. Use [ns_players()] instead.
#' 
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

#' Get the summary of a player
#' 
#' `get_player_landing()` is deprecated. Use [ns_player_summary()] instead.
#' 
#' @export

get_player_landing <- function(player = 8480039) {
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

#' Get the game log of a player for a season and game type
#' 
#' `get_player_game_log()` is deprecated. Use [ns_player_game_log()] instead.
#' 
#' @export

get_player_game_log <- function(
    player    = 8480039, 
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
