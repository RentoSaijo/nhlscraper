#' Access all the ESPN athletes (players)
#' 
#' `get_espn_athletes()` is deprecated. Use [espn_players()] instead.
#' 
#' @returns data.frame with one row per ESPN athlete (player)
#' @export

get_espn_athletes <- function() {
  .Deprecated(
    new     = 'espn_players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_athletes()` is deprecated.',
      'Use `espn_players()` instead.'
    )
  )
  espn_players()
}

#' Access the ESPN summary for an athlete (player) and season
#' 
#' `get_espn_athlete()` is defunct. Use [espn_player_summary()] instead.
#' 
#' @export

get_espn_athlete <- function() {
  .Defunct(
    new     = 'espn_player_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_athlete()` is defunct.',
      'Use `espn_player_summary()` instead.'
    )
  )
}