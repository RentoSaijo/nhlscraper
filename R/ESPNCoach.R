#' Get ESPN coaches by season
#' 
#' `get_espn_coaches()` retrieves ESPN hyperlinks for each coach for a given `season`; the hyperlinks are formatted in `base/seasons/{ESPN Season ID}/coaches/{ESPN Coach ID}?query`. Access `get_seasons()` for `season` reference. May soon be reworked to only return the ESPN Coach IDs.

#' 
#' @param season integer in YYYY
#' @return tibble with one row per coach
#' @examples
#' ESPN_coaches_20242025 <- get_espn_coaches(2025)
#' @export

get_espn_coaches <- function(season=get_season_now()$seasonId%%10000) {
  out <- espn_api(
    path=sprintf('seasons/%s/coaches', season),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}

#' Get coach by ESPN Coach ID (and season)
#' 
#' `get_espn_coach()` retrieves information on a `coach` for a given `season` or all seasons, including but not limited to his or her name and head-shot URL. Access `get_espn_coaches()` for `coach` and `get_seasons()` for `season` references.
#'
#' @param coach integer ESPN Coach ID
#' @param season integer/string in YYYY or 'all'
#' @return list with various items
#' @examples
#' ESPN_Paul_Maurice <- get_espn_coach(coach=5033, season='all')
#' @export

get_espn_coach <- function(coach=5033, season='all') {
  p <- paste0('coaches/', coach)
  if (season!='all') {
    p <- sprintf('seasons/%s/%s', season, p)
  }
  out <- espn_api(
    path=p,
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  keeps <- setdiff(names(out), c(
    'college',
    'careerRecords'
  ))
  return(out[keeps])
}

#' Get career coaching records by ESPN Coach ID and game-type
#' 
#' `get_espn_coach_career()` retrieves information on each statistic for a given set of `coach` and `game_type`, including but not limited to their name, abbreviation, description, and value. Access `get_espn_coaches()` for `coach` reference.
#' 
#' @param coach integer ESPN Coach ID
#' @param game_type integer where 0=total, 1=regular, and 2=playoffs
#' @return tibble with one row per statistic
#' @examples
#' ESPN_Paul_Maurice_career <- get_espn_coach_career(coach=5033, game_type=0)
#' @export

get_espn_coach_career <- function(coach=5033, game_type=0) {
  out <- espn_api(
    path=sprintf('coaches/%s/record/%s', coach, game_type),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$stats))
}
