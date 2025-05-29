#' Get standings by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per team
#' @export

get_standings <- function(date='now') {
  out <- nhl_api(
    path=sprintf('standings/%s', date),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$standings))
}

#' Get standings information for each season
#' 
#' @return tibble with one row per season
#' @export

get_standings_information <- function() {
  out <- nhl_api(
    path='standings-season',
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$seasons))
}
