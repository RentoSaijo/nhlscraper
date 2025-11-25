#' Access all the awards
#' 
#' `get_awards()` is deprecated. Use [awards()] instead.
#' 
#' @returns data.frame with one row per award
#' @export

get_awards <- function() {
  .Deprecated(
    new     = 'awards()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_awards()` is deprecated.',
      'Use `awards()` instead.'
    )
  )
  awards()
}

#' Access all the award winners/finalists
#' 
#' `get_award_winners()` is deprecated. Use [award_winners()] instead.
#' 
#' @returns data.frame with one row per winner/finalist
#' @export

get_award_winners <- function() {
  .Deprecated(
    new     = 'award_winners()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_award_winners()` is deprecated.',
      'Use `award_winners()` instead.'
    )
  )
  award_winners()
}
