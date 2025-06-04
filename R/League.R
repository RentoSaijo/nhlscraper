#' Get standings by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per team
#' @export

get_standings <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=F)
  }
  out <- nhl_api(
    path=sprintf('standings/%s', date),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$standings))
}

#' Get standings information for all seasons
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

#' Get schedule by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per game
#' @export

get_schedule <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=F)
  }
  out <- nhl_api(
    path=sprintf('schedule/%s', date),
    query=list(),
    stats_rest=F
  )
  if (is.null(out$gameWeek)) {
    return(tibble::tibble())
  }
  sub <- out$gameWeek[out$gameWeek$date==date, , drop=F]
  if (nrow(sub)==0) {
    return(tibble::tibble())
  }
  tibble::as_tibble(sub$games[[1]])
}

#' Get all seasons
#' 
#' @return tibble with one row per season
#' @export

get_seasons <- function() {
  out <- nhl_api(
    path='season',
    query=list(),
    stats_rest=T
  )
  return(tibble::as_tibble(out$data))
}
