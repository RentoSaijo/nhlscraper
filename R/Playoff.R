#' Get playoff series carousel by season and round
#' 
#' @param season integer Season in YYYYYYYY
#' @param round integer Round of 1:4
#' @return tibble with one row per match-up
#' @examples
#' carousel_20242025_2 <- get_series_carousel(season=20242025, round=2)
#' @export

get_series_carousel <- function(season=get_season_now()$seasonId, round=1) {
  out <- nhl_api(
    path=sprintf('playoff-series/carousel/%s/', season),
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out$rounds$series[[round]]))
}

#' Get playoff series schedule
#' 
#' @param season integer Season in YYYYYYYY
#' @param series string 1-letter series code
#' @return tibble with one row per game
#' @examples
#' COL_DAL_schedule_20242025 <- get_series_schedule(season=20242025, series='f')
#' @export

get_series_schedule <- function(season=get_season_now()$seasonId, series='a') {
  out <- nhl_api(
    path=sprintf('schedule/playoff-series/%s/%s', season, series),
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out$games))
}

#' Get playoff bracket by year
#' 
#' @param year integer Year in YYYY
#' @return tibble with one row per match-up
#' @examples
#' bracket_2025 <- get_playoff_bracket(year=2025)
#' @export

get_playoff_bracket <- function(year=get_season_now()$seasonId%%10000) {
  out <- nhl_api(
    path=sprintf('playoff-bracket/%s', year),
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out$series))
}
