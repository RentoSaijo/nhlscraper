#' Access all the franchises
#' 
#' `get_franchises()` is deprecated. Use [franchises()] instead.
#' 
#' @returns data.frame with one row per franchise
#' @export

get_franchises <- function() {
  .Deprecated(
    new     = 'franchises()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchises()` is deprecated.',
      'Use `franchises()` instead.'
    )
  )
  franchises()
}

#' Access the all-time statistics for all the franchises by team and game type
#' 
#' `get_franchise_team_totals()` is deprecated. Use 
#' [franchise_team_statistics()] instead.
#'
#' @returns data.frame with one row per team per franchise per game type
#' @export

get_franchise_team_totals <- function() {
  .Deprecated(
    new     = 'franchise_team_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_team_totals()` is deprecated.',
      'Use `franchise_team_statistics()` instead.'
    )
  )
  franchise_team_statistics()
}

#' Access the statistics for all the franchises by season and game type
#' 
#' `get_franchise_season_by_season()` is deprecated. Use 
#' [franchise_season_statistics()] instead.
#' 
#' @returns data.frame with one row per franchise per season per game type
#' @export

get_franchise_season_by_season <- function() {
  .Deprecated(
    new     = 'franchise_season_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_season_by_season()` is deprecated.',
      'Use `franchise_season_statistics()` instead.'
    )
  )
  franchise_season_statistics()
}

#' Access the all-time statistics versus other franchises for all the 
#' franchises by game type
#' 
#' `get_franchise_vs_franchise()` is deprecated. Use 
#' [franchise_versus_franchise()] instead.
#' 
#' @returns data.frame with one row per franchise per franchise per game type
#' @export

get_franchise_vs_franchise <- function() {
  .Deprecated(
    new     = 'franchise_versus_franchise()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_vs_franchise()` is deprecated.',
      'Use `franchise_versus_franchise()` instead.'
    )
  )
  franchise_versus_franchise()
}
