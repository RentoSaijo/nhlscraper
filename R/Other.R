#' Access the glossary
#'
#' `glossary()` retrieves the glossary as a `data.frame` where each row represents terminology and includes detail on reference definitions and rules-framework information.
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
#' `countries()` retrieves all the countries as a `data.frame` where each row represents country and includes detail on reference metadata, regional context, and media availability detail.
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
#' `location()` retrieves the location for a zip code as a `data.frame` where each row represents team and includes detail on venue/location geography and regional metadata.
#'
#' @param zip integer (e.g., 48304)
#'
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
#' `streams()` retrieves all the streams as a `data.frame` where each row represents stream and includes detail on reference metadata, regional context, and media availability detail.
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
#' `tv_schedule()` retrieves the NHL Network TV schedule for a date as a `data.frame` where each row represents program and includes detail on date/season filtering windows and chronological context.
#'
#' @inheritParams standings
#'
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
