#' Access the real-time ESPN injury reports
#' 
#' `get_espn_injuries()` is deprecated. Use [espn_injuries()] instead.
#' 
#' @returns nested data.frame with one row per team (outer) and player (inner)
#' @export

get_espn_injuries <- function() {
  .Deprecated(
    new     = 'espn_injuries()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_injuries()` is deprecated.',
      'Use `espn_injuries()` instead.'
    )
  )
  espn_injuries()
}

#' Access the ESPN transactions by start and end dates
#' 
#' `get_espn_transactions()` is defunct. Use [espn_transactions()] instead.
#' 
#' @export

get_espn_transactions <- function() {
  .Defunct(
    new     = 'espn_transactions()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_transactions()` is defunct.',
      'Use `espn_transactions()` instead.'
    )
  )
}

#' Access the ESPN futures for a season
#' 
#' `get_espn_futures()` is defunct. Use [espn_futures()] instead.
#' 
#' @export

get_espn_futures <- function() {
  .Defunct(
    new     = 'espn_futures()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_futures()` is defunct.',
      'Use `espn_futures()` instead.'
    )
  )
}

