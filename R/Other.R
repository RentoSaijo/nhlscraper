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
    type=1
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
    type=1
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
    type=2
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
    type=2
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
    type=2
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
    type=2
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
    type=2
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
    type=1
  )
  return(tibble::as_tibble(out))
}

#' Get all venues
#' 
#' @return tibble with one row per venue
#' @examples
#' all_venues <- get_venues()
#' @export

get_venues <- function() {
  out <- nhl_api(
    path='venue',
    type=3
  )
  return(tibble::as_tibble(out$data))
}

#' Get transactions by season
#' 
#' @param season integer Season in YYYYYYYY
#' @return tibble with one row per transaction
#' @examples
#' transactions_20242025 <- get_transactions(20242025)
#' @export

get_transactions <- function(season=get_season_now()$seasonId) {
  season <- season %/% 10000
  page <- 1
  all_transactions <- list()
  repeat {
    out <- espn_api(
      path='transactions',
      query=list(limit=1000, season=season, page=page),
      type=1
    )
    df <- tibble::as_tibble(out$transactions)
    all_transactions[[page+1]] <- df
    if (nrow(df) < 1000) {
      break
    }
    page <- page + 1
  }
  return(dplyr::bind_rows(all_transactions))
}

#' Get injury reports as of now
#' 
#' @return nested tibble with one row per team and one row per player
#' @examples
#' injuries_now <- get_injuries()
#' @export

get_injuries <- function() {
  out <- espn_api(
    path='injuries',
    query=list(limit=1000),
    type=1
  )
  return(tibble::as_tibble(out$injuries))
}

#' Get all officials
#' 
#' @return tibble with one row per official
#' @examples
#' all_officials <- get_officials()
#' @export

get_officials <- function() {
  out <- nhl_api(
    path='officials',
    type=3
  )
  return(tibble::as_tibble(out$data))
}
