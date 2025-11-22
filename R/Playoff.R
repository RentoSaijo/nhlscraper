#' Get the playoff bracket of a season
#' 
#' `ns_bracket()` retrieves information on each series for a given `season`, 
#' including but not limited to their title, abbreviation, 1-letter code, 
#' round, top and bottom seeds, and winning and losing teams' IDs. Access 
#' `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @return data.frame with one row per series
#' @examples
#' bracket_20242025 <- ns_bracket(season = 20242025)
#' @export

ns_bracket <- function(season = ns_season()$seasonId){
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/playoff-bracket/%s', as.integer(season) %% 1e4),
        type = 'w'
      )$series
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the schedule of a playoff series for a season
#' 
#' `ns_series_schedule()` retrieves information on each game for a given set of 
#' `season` and `series`, including but not limited to their ID; venue; start 
#' date and time; and home and away teams' IDs, names, and scores. Access 
#' `get_seasons()` for `season` and `get_bracket()` for `series` references.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param series one-letter code (e.g., 'F')
#' @return data.frame with one row per game
#' @examples
#' COL_DAL_schedule_20242025 <- ns_series_schedule(
#'   season = 20242025, 
#'   series = 'F'
#' )
#' @export

ns_series_schedule <- function(season = ns_season()$seasonId, series = 'a') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/schedule/playoff-series/%s/%s', 
          season, 
          tolower(series)
        ),
        type = 'w'
      )$games
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
