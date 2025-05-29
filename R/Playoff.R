#' Get playoff series carousel by season and round
#' 
#' @param season integer Season in YYYYYYYY
#' @return tibble with one row per match-up
#' @export

get_series_carousel <- function(season=20242025, round=1) {
  out <- nhl_api(
    path=sprintf('playoff-series/carousel/%s/', season),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$rounds$series[[round]]))
}

#' Get playoff series schedule
#' 
#' @param season integer Season in YYYYYYYY
#' @param series string Series code e.g. 'a'
#' @return tibble with one row per game
#' @export

get_series_schedule <- function(season=20242025, series='a') {
  out <- nhl_api(
    path=sprintf('schedule/playoff-series/%s/%s', season, series),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$games))
}

#' Get playoff bracket by year
#' 
#' @param year integer Year in YYYY
#' @return tibble with one row per match-up
#' @export

get_playoff_bracket <- function(year=2025) {
  out <- nhl_api(
    path=sprintf('playoff-bracket/%s', year),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$series))
}
