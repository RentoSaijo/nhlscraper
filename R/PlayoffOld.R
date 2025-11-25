#' Access the playoff bracket for a season
#' 
#' `get_bracket()` is deprecated. Use [ns_bracket()] instead.
#' 
#' @inheritParams ns_roster
#' @returns data.frame with one row per series
#' @export

get_bracket <- function(season = ns_season()) {
  .Deprecated(
    new     = 'ns_bracket()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_bracket()` is deprecated.',
      'Use `ns_bracket()` instead.'
    )
  )
  ns_bracket(season)
}

#' Access the playoff schedule for a season and series
#' 
#' `get_series_schedule()` is deprecated. Use [ns_series_schedule()] instead.
#' 
#' @inheritParams ns_series_schedule
#' @returns data.frame with one row per game
#' @export

get_series_schedule <- function(season = ns_season(), series = 'a') {
  .Deprecated(
    new     = 'ns_series_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_series_schedule()` is deprecated.',
      'Use `ns_series_schedule()` instead.'
    )
  )
  ns_series_schedule(season, series)
}

#' Access the playoff series for a season and round
#' 
#' `get_series()` is defunct.
#' 
#' @export

get_series <- function(season = ns_season(), round = 1) {
  .Defunct(
    msg = paste(
      '`get_series()` is defunct.'
    )
  )
}
