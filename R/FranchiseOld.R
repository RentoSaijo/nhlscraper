#' Get all the franchises
#' 
#' `get_franchises()` is deprecated. Use [ns_franchises()] instead.
#' 
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

#' Get the season-by-season results for all the franchises
#' 
#' `get_franchise_season_by_season()` is deprecated. Use 
#' [ns_franchise_season_by_season()] instead.
#' @export

get_franchise_season_by_season <- function() {
  .Deprecated(
    new     = 'ns_franchise_season_by_season()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_season_by_season()` is deprecated.',
      'Use `ns_franchise_season_by_season()` instead.'
    )
  )
  ns_franchise_season_by_season()
}
