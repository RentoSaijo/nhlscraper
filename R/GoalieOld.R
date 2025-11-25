#' Access the goalie statistics leaders for a season, game type, and category
#' 
#' `get_goalie_leaders()` is deprecated. Use [goalie_leaders()] instead.
#'
#' @inheritParams roster_statistics
#' @param category character of 'wins', 'shutouts', 'savePctg', or 
#' 'goalsAgainstAverage'
#' @returns data.frame with one row per player
#' @export

get_goalie_leaders <- function(
  season    = 'current',
  game_type = '',
  category  = 'wins'
) {
  .Deprecated(
    new     = 'goalie_leaders()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_leaders()` is deprecated.',
      'Use `goalie_leaders()` instead.'
    )
  )
  category <- switch(
    category,
    wins                = 'w',
    shutouts            = 's',
    savePctg            = 's%',
    goalsAgainstAverage = 'gaa'
  )
  goalie_leaders(season, game_type, category)
}

#' Access the goalies on milestone watch
#' 
#' `get_goalie_milestones()` is deprecated. Use [goalie_milestones()] 
#' instead.
#'
#' @returns data.frame with one row per player
#' @export

get_goalie_milestones <- function() {
  .Deprecated(
    new     = 'goalie_milestones()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_milestones()` is deprecated.',
      'Use `goalie_milestones()` instead.'
    )
  )
  goalie_milestones()
}

#' Access all the goalies for a range of seasons
#' 
#' `get_goalies()` is defunct. Use [players()] instead.
#'
#' @export

get_goalies <- function() {
  .Defunct(
    new     = 'players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalies()` is defunct',
      'Use `players()` instead.'
    )
  )
}

#' Access various reports for all the goalies by season or game
#' 
#' `get_goalie_statistics()` is defunct. Use [goalies_season_report()] or 
#' [goalie_game_report()] instead.
#' 
#' @export

get_goalie_statistics <- function() {
  .Defunct(
    new     = 'goalies_season_report()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_statistics()` is defunct.',
      'Use `goalies_season_report()` and/or `goalie_game_report()` instead.'
    )
  )
}
