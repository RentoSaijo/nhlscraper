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

#' Get all franchises' season-by-season results
#' 
#' `get_franchise_season_by_season()` retrieves information on each franchise's season, including but not limited to their ID, decision, final playoff round, and statistics.
#' 
#' @return tibble with one row per franchise's season
#' @examples
#' all_franchise_sbs <- get_franchise_season_by_season()
#' @export

get_franchise_season_by_season <- function() {
  out <- nhl_api(
    path='franchise-season-results',
    type=3
  )
  return(tibble::as_tibble(out$data))
}
