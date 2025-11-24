#' Get all the franchises
#' 
#' `get_franchises()` is deprecated. Use [ns_franchises()] instead.
#' 
#' @return data.frame with one row per franchise
#' @export

get_franchises <- function() {
  .Deprecated(
    new     = 'ns_franchises()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchises()` is deprecated.',
      'Use `ns_franchises()` instead.'
    )
  )
  ns_franchises()
}

#' Get the all-time statistics for all the franchises by team and game type
#' 
#' `get_franchise_team_totals()` is deprecated. Use 
#' [ns_franchise_team_statistics()] instead.
#'
#' @return data.frame with one row per team per franchise per game type
#' @export

get_franchise_team_totals <- function() {
  .Deprecated(
    new     = 'ns_franchise_team_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_team_totals()` is deprecated.',
      'Use `ns_franchise_team_statistics()` instead.'
    )
  )
  ns_franchise_team_statistics()
}

#' Get statistics for all the franchises by season and game type
#' 
#' `get_franchise_season_by_season()` is deprecated. Use 
#' [ns_franchise_season_statistics()] instead.
#' 
#' @return data.frame with one row per franchise per season per game type
#' @export

get_franchise_season_by_season <- function() {
  .Deprecated(
    new     = 'ns_franchise_season_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_season_by_season()` is deprecated.',
      'Use `ns_franchise_season_statistics()` instead.'
    )
  )
  ns_franchise_season_statistics()
}

#' Get the all-time statistics versus other franchises for all the franchises 
#' by game type
#' 
#' `get_franchise_vs_franchise()` is deprecated. Use 
#' [ns_franchise_versus_franchise()] instead.
#' 
#' @return data.frame with one row per franchise per franchise per game type
#' @export

get_franchise_vs_franchise <- function() {
  .Deprecated(
    new     = 'ns_franchise_versus_franchise()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_vs_franchise()` is deprecated.',
      'Use `ns_franchise_versus_franchise()` instead.'
    )
  )
  ns_franchise_versus_franchise()
}
