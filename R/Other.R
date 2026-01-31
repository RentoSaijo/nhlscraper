#' Access the glossary
#' 
#' `glossary()` scrapes the glossary.
#' 
#' @returns data.frame with one row per terminology
#' @examples
#' glossary <- glossary()
#' @export

glossary <- function() {
  tryCatch({
    terms <- nhl_api(
      path = 'en/glossary',
      type = 's'
    )$data
    names(terms)[names(terms) == 'id'] <- 'terminologyId'
    terms
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the countries
#' 
#' `countries` scrapes all the countries.
#' 
#' @returns data.frame with one row per country
#' @examples
#' all_countries <- countries()
#' @export

countries <- function() {
  tryCatch({
    countries <- nhl_api(
      path = 'en/country',
      type = 's'
    )$data
    names(countries)[names(countries) == 'id'] <- 'countryId'
    countries
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the location for a zip code
#' 
#' `location()` scrapes the location for a given `zip` code.
#' 
#' @param zip integer (e.g., 48304)
#' @returns data.frame with one row per team
#' @examples
#' Cranbrook_Schools <- location(48304)
#' @export

location <- function(zip = 10001) {
  tryCatch(
    expr = {
      location <- nhl_api(
        path = sprintf('v1/postal-lookup/%s', zip),
        type = 'w'
      )
      location[0, ]
      location
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access all the streams
#' 
#' `streams()` scrapes all the streams.
#' 
#' @returns data.frame with one row per stream
#' @examples
#' all_streams <- streams()
#' @export

streams <- function() {
  tryCatch({
    nhl_api(
      path = 'v1/where-to-watch',
      type = 'w'
    )
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the NHL Network TV schedule for a date
#' 
#' `tv_schedule()` scrapes the NHL Network TV schedule for a given `date`.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per program
#' @examples
#' tv_schedule_Halloween_2025 <- tv_schedule(date = '2025-10-31')
#' @export

tv_schedule <- function(date = 'now') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/network/tv-schedule/%s', date),
        type = 'w'
      )$broadcasts
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
