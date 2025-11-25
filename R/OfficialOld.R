#' Access all the officials
#' 
#' `get_officials()` is deprecated. Use [ns_officials()] instead.
#' 
#' @returns data.frame with one row per official
#' @export

get_officials <- function() {
  .Deprecated(
    new     = 'ns_officials()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_officials()` is deprecated.',
      'Use `ns_officials()` instead.'
    )
  )
  ns_officials()
}
