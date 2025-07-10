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

#' Get ESPN futures by season
#' 
#' @param season integer Season in YYYYYYY
#' @return tibble with one row per future
#' @examples
#' futures_20242025 <- get_futures(20242025)
#' @export

get_futures <- function(season=get_season_now$seasonId) {
  out <- espn_api(
    path=sprintf('seasons/%s/futures', nhl_season_to_espn_season(season)),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}
