#' Get standings by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per team
#' @examples
#' standings_2025_01_02 <- get_standings(date='2025-01-02')
#' @export

get_standings <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=FALSE)
  }
  out <- nhl_api(
    path=sprintf('standings/%s', date),
    type=1
  )
  return(tibble::as_tibble(out$standings))
}

#' Get standings information for all seasons
#' 
#' @return tibble with one row per season
#' @examples
#' standings_info <- get_standings_information()
#' @export

get_standings_information <- function() {
  out <- nhl_api(
    path='standings-season',
    type=1
  )
  return(tibble::as_tibble(out$seasons))
}

#' Get schedule by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per game
#' @examples
#' schedule_2025_01_02 <- get_schedule(date='2025-01-02')
#' @export

get_schedule <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=FALSE)
  }
  out <- nhl_api(
    path=sprintf('schedule/%s', date),
    type=1
  )
  if (is.null(out$gameWeek)) {
    return(tibble::tibble())
  }
  sub <- out$gameWeek[out$gameWeek$date==date, , drop=FALSE]
  if (nrow(sub)==0) {
    return(tibble::tibble())
  }
  tibble::as_tibble(sub$games[[1]])
}

#' Get all seasons
#' 
#' @return tibble with one row per season
#' @examples
#' all_seasons <- get_seasons()
#' @export

get_seasons <- function() {
  out <- nhl_api(
    path='season',
    type=2
  )
  return(tibble::as_tibble(out$data))
}
