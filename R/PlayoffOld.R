#' Access the playoff bracket for a season
#' 
#' `get_bracket()` is deprecated. Use [bracket()] instead.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per series
#' @export

get_bracket <- function(season = season()) {
  .Deprecated(
    new     = 'bracket()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_bracket()` is deprecated.',
      'Use `bracket()` instead.'
    )
  )
  bracket(season)
}

#' Access the playoff schedule for a season and series
#' 
#' `get_series_schedule()` is deprecated. Use [series_schedule()] instead.
#' 
#' @inheritParams series_schedule
#' @returns data.frame with one row per game
#' @export

get_series_schedule <- function(season = season(), series = 'a') {
  .Deprecated(
    new     = 'series_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_series_schedule()` is deprecated.',
      'Use `series_schedule()` instead.'
    )
  )
  series_schedule(season, series)
}

#' Access the playoff series for a season and round
#' 
#' `get_series()` is defunct.
#' 
#' @export

get_series <- function() {
  .Defunct(
    msg = paste(
      '`get_series()` is defunct.'
    )
  )
}
