#' Get NHL partner odds as of now
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

#' Get ESPN futures as of now
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
