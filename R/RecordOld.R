#' Get all the franchises' teams' all-time totals
#' 
#' `get_franchise_team_totals()` is deprecated. Use 
#' [ns_franchise_team_totals()] instead.
#'
#' @export

get_franchise_team_totals <- function() {
  .Deprecated(
    new     = 'ns_franchise_team_totals()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_franchise_team_totals()` is deprecated.',
      'Use `ns_franchise_team_totals()` instead.'
    )
  )
  ns_franchise_team_totals()
}

#' Get all the franchises' all-time records versus other franchises
#' 
#' `get_franchise_vs_franchise()` is deprecated. Use 
#' [ns_franchise_versus_franchise()] instead.
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
