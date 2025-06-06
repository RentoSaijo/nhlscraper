#' Get TV schedule by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
#' @return tibble with one row per program
#' @examples
#' tv_schedule_2025_01_02 <- get_tv_schedule(date='2025-01-02')
#' @export

get_tv_schedule <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=FALSE)
  }
  out <- nhl_api(
    path=sprintf('network/tv-schedule/%s', date),
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out$broadcasts))
}

#' Get partner odds as of now
#' 
#' @param country string 2-letter country code e.g. 'US'
#' @return tibble with one row per game
#' @examples
#' partner_odds_now_CA <- get_partner_odds(country='CA')
#' @export

get_partner_odds <- function(country='US') {
  out <- nhl_api(
    path=sprintf('partner-game/%s/now', country),
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out$games))
}

#' Get glossary
#' 
#' @return tibble with one row per terminology
#' @examples
#' glossary <- get_glossary()
#' @export

get_glossary <- function() {
  out <- nhl_api(
    path='glossary',
    query=list(),
    stats_rest=TRUE
  )
  return(tibble::as_tibble(out$data))
}

#' Get season as of now
#' 
#' @return tibble with one row
#' @examples
#' season_now <- get_season_now()
#' @export

get_season_now <- function() {
  out <- nhl_api(
    path='componentSeason',
    query=list(),
    stats_rest=TRUE
  )
  return(tibble::as_tibble(out$data))
}

#' Get configuration for skater, goalie, and team statistics
#' 
#' @return list with 5 items
#' @examples
#' config <- get_configuration()
#' @export

get_configuration <- function() {
  out <- nhl_api(
    path='config',
    query=list(),
    stats_rest=TRUE
  )
  return(out)
}

#' Ping
#' 
#' @return boolean TRUE=status is okay and FALSE=status is not okay
#' @examples
#' online <- ping()
#' @export

ping <- function() {
  out <- nhl_api(
    path='ping',
    query=list(),
    stats_rest=TRUE
  )
  return(length(out)==0)
}

#' Get all countries
#' 
#' @return tibble with one row per country
#' @examples
#' all_countries <- get_countries()
#' @export

get_countries <- function() {
  out <- nhl_api(
    path='country',
    query=list(),
    stats_rest=TRUE
  )
  return(tibble::as_tibble(out$data))
}

#' Get all streams
#' 
#' @return tibble with one row per stream
#' @examples
#' all_streams <- get_streams()
#' @export

get_streams <- function() {
  out <- nhl_api(
    path='where-to-watch',
    query=list(),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out))
}
