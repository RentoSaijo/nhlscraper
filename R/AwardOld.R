#' Get all awards
#' 
#' `get_awards()` is deprecated. Use [ns_awards()] instead.
#' 
#' @export

get_awards <- function() {
  .Deprecated(
    new     = 'ns_awards()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_awards()` is deprecated.',
      'Use `ns_awards()` instead.'
    )
  )
  ns_awards()
}

#' Get all award winners/finalists
#' 
#' `get_award_winners()` is deprecated. Use [ns_award_winners()] instead.
#' 
#' @export

get_award_winners <- function() {
  .Deprecated(
    new     = 'ns_award_winners()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_award_winners()` is deprecated.',
      'Use `ns_award_winners()` instead.'
    )
  )
  ns_award_winners()
}
