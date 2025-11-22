#' Get the playoff bracket of a season
#' 
#' `get_bracket()` is deprecated. Use [ns_bracket()] instead.
#' 
#' @export

get_bracket <- function(season = ns_season()$seasonId) {
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

#' Get the playoff series of a round for a season
#' 
#' `get_series()` is defunct.
#' 
#' @export

get_series <- function(season = ns_season()$seasonId, round = 1) {
  .Defunct(
    msg = paste(
      '`get_series()` is defunct.'
    )
  )
}

#' Get the schedule of a playoff series for a season
#' 
#' `get_series_schedule()` is deprecated. Use [ns_series_schedule()] instead.
#' 
#' @export

get_series_schedule <- function(season = ns_season()$seasonId, series = 'a') {
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
