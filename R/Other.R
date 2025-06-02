#' Get TV schedule by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per broadcast
#' @export

get_tv_schedule <- function(date='2025-01-01') {
  out <- nhl_api(
    path=sprintf('network/tv-schedule/%s', date),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$broadcasts))
}

#' Get partner odds now
#' 
#' @param country string Country code e.g. 'US'
#' @return tibble with one row per game
#' @export

get_partner_odds <- function(country='US') {
  out <- nhl_api(
    path=sprintf('partner-game/%s/now', country),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$games))
}

#' Get glossary
#' 
#' @return tibble with one row per terminology
#' @export

get_glossary <- function() {
  out <- nhl_api(
    path='glossary',
    query=list(),
    stats_rest=T
  )
  return(tibble::as_tibble(out$data))
}

#' Get latest season
#' 
#' @return tibble with one row
#' @export

get_season_now <- function() {
  out <- nhl_api(
    path='componentSeason',
    query=list(),
    stats_rest=T
  )
  return(tibble::as_tibble(out$data))
}

#' Get configuration
#' 
#' @return list with 5 items
#' @export

get_configuration <- function() {
  out <- nhl_api(
    path='config',
    query=list(),
    stats_rest=T
  )
  return(out)
}

#' Ping
#' 
#' @return boolean T=status is okay and F=status is not okay
#' @export

ping <- function() {
  out <- nhl_api(
    path='ping',
    query=list(),
    stats_rest=T
  )
  return(length(out)==0)
}

#' Get all countries
#' 
#' @return tibble with one row per country
#' @export

get_countries <- function() {
  out <- nhl_api(
    path='country',
    query=list(),
    stats_rest=T
  )
  return(tibble::as_tibble(out$data))
}
