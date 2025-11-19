#' Get all the seasons
#' 
#' `get_seasons()` is deprecated. Use [ns_seasons()] instead.
#' 
#' @export

get_seasons <- function() {
  .Deprecated(
    new     = 'ns_seasons()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_seasons()` is deprecated.',
      'Use `ns_seasons()` instead.'
    )
  )
  ns_seasons()
}

#' Get information about the standings for all the seasons
#' 
#' `get_standings_information()` is deprecated. Use 
#' [ns_standings_information()] instead.
#' 
#' @export

get_standings_information <- function() {
  .Deprecated(
    new     = 'ns_standings_information()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_standings_information()` is deprecated.',
      'Use `ns_standings_information()` instead.'
    )
  )
  ns_standings_information()
}

#' Get the standings for a date
#' 
#' `get_standings()` is deprecated. Use [ns_standings()] instead.
#' 
#' @export

get_standings <- function(date = '2025-01-01') {
  .Deprecated(
    new     = 'ns_standings()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_standings()` is deprecated.',
      'Use `ns_standings()` instead.'
    )
  )
  ns_standings(date)
}

#' Get the schedule for a date
#' 
#' `get_schedule()` is deprecated. Use [ns_schedule()] instead.
#' 
#' @export

get_schedule <- function(date = '2025-01-01') {
  .Deprecated(
    new     = 'ns_schedule()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_schedule()` is deprecated.',
      'Use `ns_schedule()` instead.'
    )
  )
  ns_schedule(date)
}
