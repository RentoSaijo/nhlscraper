#' Get the goalies for a range of seasons
#' 
#' `get_goalies()` is defunct. Use [ns_players()] instead.
#'
#' @export

get_goalies <- function() {
  .Defunct(
    new     = 'ns_players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalies()` is defunct',
      'Use `ns_players()` instead.'
    )
  )
}

#' Get goalie statistics
#' 
#' `get_goalie_statistics()` is defunct. Use [ns_goalie_statistics()] instead.
#'
#' @export

get_goalie_statistics <- function() {
  .Defunct(
    new     = 'ns_goalie_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_statistics()` is defunct',
      'Use `ns_goalie_statistics()` instead.'
    )
  )
}

#' Get the goalie statistics leaders for a season, game type, and category
#' 
#' `get_goalie_leaders()` is deprecated. Use [ns_goalie_leaders()] instead.
#'
#' @export

get_goalie_leaders <- function(
    season    = 'current',
    game_type = '',
    category  = 'wins'
) {
  .Deprecated(
    new     = 'ns_goalie_leaders()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_leaders()` is deprecated.',
      'Use `ns_goalie_leaders()` instead.'
    )
  )
  category <- switch(
    category,
    wins                = 'w',
    shutouts            = 's',
    savePctg            = 's%',
    goalsAgainstAverage = 'gaa'
  )
  ns_goalie_leaders(season, game_type, category)
}

#' Get the goalies on milestone watch
#' 
#' `get_goalie_milestones()` is deprecated. Use [ns_goalie_milestones()] 
#' instead.
#'
#' @export

get_goalie_milestones <- function() {
  .Deprecated(
    new     = 'ns_goalie_milestones()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_goalie_milestones()` is deprecated.',
      'Use `ns_goalie_milestones()` instead.'
    )
  )
  ns_goalie_milestones()
}
