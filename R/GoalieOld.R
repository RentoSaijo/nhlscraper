#' Get the goalies for a range of seasons
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

#' Get goalie statistics
#' 
#' `get_goalie_statistics()` is defunct. Use [goalie_statistics()] instead.
#'
#' @export

get_goalie_statistics <- function() {
  .Defunct(
    new     = 'goalie_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_statistics()` is defunct',
      'Use `goalie_statistics()` instead.'
    )
  )
}

#' Get the goalie statistics leaders for a season, game type, and category
#' 
#' `get_goalie_leaders()` is deprecated. Use [goalie_leaders()] instead.
#'
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

#' Get the goalies on milestone watch
#' 
#' `get_goalie_milestones()` is deprecated. Use [goalie_milestones()] 
#' instead.
#'
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
