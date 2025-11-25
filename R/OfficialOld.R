#' Access all the officials
#' 
#' `get_officials()` is deprecated. Use [officials()] instead.
#' 
#' @returns data.frame with one row per official
#' @export

get_officials <- function() {
  .Deprecated(
    new     = 'officials()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_officials()` is deprecated.',
      'Use `officials()` instead.'
    )
  )
  officials()
}
