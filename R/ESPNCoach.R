#' Get ESPN coaches by season
#' 
#' @param season integer Season in YYYY
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
#' @param coach integer ESPN Coach ID
#' @param season integer/string Season in YYYY or '' for all seasons
#' @return list with various items
#' @examples
#' ESPN_Paul_Maurice <- get_espn_coach(coach=5033, season='')
#' @export

get_espn_coach <- function(coach=5033, season='') {
  p <- paste0('coaches/', coach)
  if (season!='') {
    p <- sprintf('seasons/%s/%s', season, p)
  }
  out <- espn_api(
    path=p,
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  keeps <- setdiff(names(out), c(
    'college'
  ))
  return(out[keeps])
}

#' Get coach career records by ESPN Coach ID and game-type
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
