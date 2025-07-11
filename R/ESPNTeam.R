#' Get ESPN teams by season
#' 
#' @param season integer Season in YYYY
#' @return tibble with one row per team
#' @examples
#' ESPN_teams_20242025 <- get_espn_teams(2025)
#' @export

get_espn_teams <- function(season=get_season_now()$seasonId%%10000) {
  out <- espn_api(
    path=sprintf('seasons/%s/teams', season),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}

#' Get team by season and ESPN Team ID
#' 
#' @param season integer Season in YYYY
#' @param team integer ESPN Team ID
#' @return list with various items
#' @examples
#' ESPN_BOS_20242025 <- get_espn_team(season=2025, team=1)
#' @export

get_espn_team <- function(season=get_season_now()$seasonId%%10000, team=1) {
  out <- espn_api(
    path=sprintf('seasons/%s/teams/%s', season, team),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  keeps <- setdiff(names(out), c(
    'record',
    'venue',
    'groups',
    'statistics',
    'leaders',
    'injuries',
    'awards',
    'franchise',
    'events',
    'transactions',
    'athletes',
    'coaches'
  ))
  return(out[keeps])
}
