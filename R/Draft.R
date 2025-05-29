#' Get draft rankings by year and player-type
#' 
#' @param year integer Year in YYYY
#' @param player_type integer Player-type where 1=NA Skaters, 2=Int. Skaters, 3=NA Goalies, and 4=Int. Goalies
#' @return tibble with one row per player
#' @export

get_draft_rankings <- function(year=2025, player_type=1) {
  out <- nhl_api(
    path=sprintf('draft/rankings/%s/%s', year, player_type),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$rankings))
}

#' Get draft picks by year (and round)
#' 
#' @param year integer Year in YYYY
#' @param round integer/string Round of 1:7 or 'all'
#' @return tibble with one row per pick
#' @export

get_draft_picks <- function(year=2024, round=1) {
  out <- nhl_api(
    path=sprintf('draft/picks/%s/%s', year, round),
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$picks))
}

#' Get draft tracker now
#' 
#' @return tibble with one row per pick
#' @export

get_draft_tracker <- function() {
  out <- nhl_api(
    path='draft-tracker/picks/now',
    query=list(),
    stats_rest=F
  )
  return(tibble::as_tibble(out$picks))
}
