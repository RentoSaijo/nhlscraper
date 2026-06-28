# Other Functions ---------------------------------------------------------

#' Access the glossary
#'
#' `glossary()` returns NHL glossary terms with one row per term and normalized
#' terminology IDs/names.
#'
#' @returns data.frame with one row per terminology
#' @examples
#' glossary <- glossary()
#' @export
glossary <- function() {
  tryCatch({
    terms <- .nhl_api(
      path = 'en/glossary',
      type = 's'
    )$data
    names(terms)[names(terms) == 'id']       <- 'terminologyId'
    names(terms)[names(terms) == 'fullName'] <- 'terminologyFullName'
    terms
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the countries
#'
#' `countries()` returns the stats API country catalog with one row per country
#' and normalized two-/three-letter country fields.
#'
#' @returns data.frame with one row per country
#' @examples
#' all_countries <- countries()
#' @export
countries <- function() {
  tryCatch({
    countries <- .nhl_api(
      path = 'en/country',
      type = 's'
    )$data
    names(countries)[names(countries) == 'id']           <- 'countryId'
    names(countries)[names(countries) == 'country3Code'] <- 'countryTriCode'
    countries
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the location for a zip code
#'
#' `location()` returns the NHL postal lookup result for one ZIP/postal code,
#' including country, region, and related local-market fields when available.
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
      location <- .nhl_api(
        path = sprintf('v1/postal-lookup/%s', zip),
        type = 'w'
      )
      location[0, ]
      names(location)[names(location) == 'country'] <- 'countryCode'
      names(location) <- .normalize_locale_names(names(location))
      names(location) <- .normalize_team_abbrev_cols(names(location))
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
#' `streams()` returns the public "where to watch" payload for the current
#' region, including broadcast/streaming providers when the endpoint is
#' available.
#'
#' @returns data.frame with one row per stream
#' @examples
#' all_streams <- streams()
#' @export
streams <- function() {
  tryCatch({
    .nhl_api(
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
#' `tv_schedule()` returns NHL Network broadcast schedule rows for one date,
#' with one row per program/broadcast item.
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
      .nhl_api(
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
