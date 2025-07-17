#' Get ESPN teams by season
#' 
#' `get_espn_teams()` retrieves ESPN hyperlinks for each team for a given `season`; the hyperlinks are formatted in `base/seasons/{ESPN Season ID}/coaches/{ESPN Team ID}?query`. Access `get_seasons()` for `season` reference. May soon be reworked to only return the ESPN Team IDs.
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
#' `get_espn_team()` retrieves information on a `team` for a given `season`, including but not limited to its name and logo URL. Access `get_espn_teams()` for `team` and `get_seasons()` for `season` references.
#' 
#' @param team integer ESPN Team ID
#' @param season integer Season in YYYY
#' @return list with various items
#' @examples
#' ESPN_BOS_20242025 <- get_espn_team(team=1, season=2025)
#' @export

get_espn_team <- function(team=1, season=get_season_now()$seasonId%%10000) {
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
