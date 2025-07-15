#' Ping
#' 
#' `ping()` retrieves information on the API status.
#' 
#' @return boolean TRUE=OK
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

#' Get glossary
#' 
#' `get_glossary()` retrieves information on each terminology, including but not limited to their definition and abbreviation.
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

#' Get configuration for skater, goalie, and team statistics
#' 
#' `get_configuration()` retrieves information on the outputs of the possible combinations of inputs for `get_team_statistics()`, `get_skater_statistics()`, and `get_goalie_statistics()`.
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

#' Get all countries
#' 
#' `get_countries()` retrieves information on each country, including but not limited to their ID, name, 2-letter code, and 3-letter code.
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

#' Get all venues
#' 
#' `get_venues()` retrieves information on each venue, including but not limited to their ID, name, and location.
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

#' Get attendance for all seasons
#' 
#' `get_attendance()` retrieves information on each season, including but not limited to their ID and regular and playoff attendance. May soon be merged with `get_seasons()`.
#' 
#' @return tibble with one row per season
#' @examples
#' all_attendance <- get_attendance()
#' @export

get_attendance <- function() {
  out <- nhl_api(
    path='attendance',
    type=3
  )
  return(tibble::as_tibble(out$data))
}

#' Get all officials
#' 
#' `get_officials()` retrieves information on each official, including but not limited to their ID, name, and birth date and location.
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

#' Get all streams
#' 
#' `get_streams()` retrieves information on each stream, including but not limited to their ID, name, and URL.
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

#' Get TV schedule by date
#' 
#' `get_tv_schedule()` retrieves information on each TV program for a given `date`, including but not limited to their title, description, start and end times, and broadcast status. Access `get_seasons()` for `date` reference.
#' 
#' @param date string in 'YYYY-MM-DD'
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

#' Get season as of now
#' 
#' `get_season_now()` retrieves information on the current season, including but not limited to its ID and game-type.
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

#' Get partner odds as of now
#' 
#' `get_partner_odds()` retrieves partner-provided information on each game for a given `country`, including but not limited to their ID and home and away team odds. Access `get_countries()` for `country` reference.
#' 
#' @param country string 2-letter Code
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
