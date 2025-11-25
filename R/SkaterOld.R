#' Get the skaters for a range of seasons
#' 
#' `get_skaters()` is defunct. Use [ns_players()] instead.
#'
#' @export

get_skaters <- function() {
  .Defunct(
    new     = 'ns_players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skaters()` is defunct.',
      'Use `ns_players()` instead.'
    )
  )
}

#' Get skater statistics
#' 
#' `get_skater_statistics()` is defunct. Use [ns_skater_statistics()] instead.
#'
#' @export

get_skater_statistics <- function() {
  .Defunct(
    new     = 'ns_skater_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skater_statistics()` is defunct.',
      'Use `ns_skater_statistics()` instead.'
    )
  )
}

#' Get the skater statistics leaders for a season, game type, and category
#' 
#' `get_skater_leaders()` is deprecated. Use [ns_skater_leaders()] instead.
#'
#' @export

get_skater_leaders <- function(
    season    = 'current',
    game_type = '',
    category  = 'points'
) {
  .Deprecated(
    new     = 'ns_skater_leaders()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skater_leaders()` is deprecated.',
      'Use `ns_skater_leaders()` instead.'
    )
  )
  category <- switch(
    category,
    assists        = 'a',
    goals          = 'g',
    goalsSh        = 'shg',
    goalsPp        = 'ppg',
    points         = 'p',
    penaltyMins    = 'pim',
    toi            = 'toi',
    plusMinus      = 'pm',
    faceoffLeaders = 'f'
  )
  ns_skater_leaders(season, game_type, category)
}

#' Get the skaters on milestone watch
#' 
#' `get_skater_milestones()` is deprecated. Use [ns_skater_milestones()] 
#' instead.
#'
#' @export

get_skater_milestones <- function() {
  .Deprecated(
    new     = 'ns_skater_milestones()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skater_milestones()` is deprecated.',
      'Use `ns_skater_milestones()` instead.'
    )
  )
  ns_skater_milestones()
}
