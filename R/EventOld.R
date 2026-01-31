#' Access all the penalty shots
#' 
#' `ps()` is deprecated. Use [penalty_shots()] instead.
#'
#' @returns data.frame with one row per penalty shot
#' @export

ps <- function() {
  .Deprecated(
    new     = 'penalty_shots()',
    package = 'nhlscraper',
    msg     = paste(
      '`ps()` is deprecated.',
      'Use `penalty_shots()` instead.'
    )
  )
  penalty_shots()
}
