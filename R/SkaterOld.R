#' Access the skater statistics leaders for a season, game type, and category
#' 
#' `get_skater_leaders()` is deprecated. Use [skater_leaders()] instead.
#' 
#' @inheritParams roster_statistics
#' @param category character of 'assists', 'goals', 'goalsSh', 'goalsPp', 
#' 'points, 'penaltyMins', 'toi', 'plusMinus', or 'faceoffLeaders'
#' @returns data.frame with one row per player
#' @export

get_skater_leaders <- function(
  season    = 'current',
  game_type = '',
  category  = 'points'
) {
  .Deprecated(
    new     = 'skater_leaders()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skater_leaders()` is deprecated.',
      'Use `skater_leaders()` instead.'
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
  skater_leaders(season, game_type, category)
}

#' Access the skaters on milestone watch
#' 
#' `get_skater_milestones()` is deprecated. Use [skater_milestones()] 
#' instead.
#'
#' @returns data.frame with one row per player
#' @export

get_skater_milestones <- function() {
  .Deprecated(
    new     = 'skater_milestones()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skater_milestones()` is deprecated.',
      'Use `skater_milestones()` instead.'
    )
  )
  skater_milestones()
}

#' Access all the skaters for a range of seasons
#' 
#' `get_skaters()` is defunct. Use [players()] instead.
#'
#' @export

get_skaters <- function() {
  .Defunct(
    new     = 'players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skaters()` is defunct.',
      'Use `players()` instead.'
    )
  )
}

#' Access various reports for all the skaters by season or game
#' 
#' `get_skater_statistics()` is defunct. Use [skater_season_report()] or 
#' [skater_game_report()] instead.
#' 
#' @export

get_skater_statistics <- function() {
  .Defunct(
    new     = 'skater_season_report()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_skater_statistics()` is defunct.',
      'Use `skater_season_report()` and/or `skater_game_report()` instead.'
    )
  )
}
