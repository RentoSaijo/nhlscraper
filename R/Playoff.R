#' Get bracket by season
#' 
#' `get_bracket()` retrieves information on each series for a given `season`, including but not limited to their title, abbreviation, 1-letter code, round, top and bottom seeds, and winning and losing teams' IDs. Access `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY
#' @return tibble with one row per series
#' @examples
#' bracket_20242025 <- get_bracket(season=20242025)
#' @export

get_bracket <- function(season=get_season_now()$seasonId-1) {
  out <- nhl_api(
    path=sprintf('playoff-bracket/%s', season%%10000),
    type=1
  )
  return(tibble::as_tibble(out$series))
}

#' Get series by season and round
#' 
#' `get_series()` retrieves information on each series for a given set of `season` and `round`, including but not limited to their label, 1-letter code, top and bottom seeds, and winning and losing teams' IDs. Access `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY
#' @param round integer of 1:4
#' @return tibble with one row per series
#' @examples
#' CF_series_20242025 <- get_series(season=20242025, round=3)
#' @export

get_series <- function(season=get_season_now()$seasonId, round=1) {
  out <- nhl_api(
    path=sprintf('playoff-series/carousel/%s/', season),
    type=1
  )
  return(tibble::as_tibble(out$rounds$series[[round]]))
}

#' Get schedule by season and series
#' 
#' `get_series_schedule()` retrieves information on each game for a given set of `season` and `series`, including but not limited to their ID; venue; start date and time; and home and away teams' IDs, names, and scores. Access `get_seasons()` for `season` and `get_bracket()` for `series` references.
#' 
#' @param season integer in YYYYYYYY
#' @param series string 1-letter Code
#' @return tibble with one row per game
#' @examples
#' COL_DAL_schedule_20242025 <- get_series_schedule(season=20242025, series='f')
#' @export

get_series_schedule <- function(season=get_season_now()$seasonId, series='a') {
  out <- nhl_api(
    path=sprintf('schedule/playoff-series/%s/%s', season, series),
    type=1
  )
  return(tibble::as_tibble(out$games))
}
