#' Access all the awards
#' 
#' `get_awards()` is deprecated. Use [ns_awards()] instead.
#' 
#' @returns data.frame with one row per award
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

#' Access all the award winners/finalists
#' 
#' `get_award_winners()` is deprecated. Use [ns_award_winners()] instead.
#' 
#' @returns data.frame with one row per winner/finalist
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
