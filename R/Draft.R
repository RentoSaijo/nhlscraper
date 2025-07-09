#' Get draft rankings by year and player-type
#' 
#' @param year integer Year in YYYY
#' @param player_type integer Player-type where 1=NA Skaters, 2=Int. Skaters, 
#'                    3=NA Goalies, and 4=Int. Goalies
#' @return tibble with one row per player
#' @examples
#' draft_rankings_2025 <- get_draft_rankings(year=2025)
#' @export

get_draft_rankings <- function(
    year=get_season_now()$seasonId%%10000,
    player_type=1
  ) {
  out <- nhl_api(
    path=sprintf('draft/rankings/%s/%s', year, player_type),
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out$rankings))
}

#' Get draft picks by year (and round)
#' 
#' @param year integer Year in YYYY
#' @param round integer or string Round of 1:7 or 'all'
#' @return tibble with one row per pick
#' @examples
#' draft_picks_2024 <- get_draft_picks(year=2024, round='all')
#' @export

get_draft_picks <- function(
    year=get_season_now()$seasonId%%10000-1,
    round='all'
  ) {
  out <- nhl_api(
    path=sprintf('draft/picks/%s/%s', year, round),
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out$picks))
}

#' Get draft tracker as of now
#' 
#' @return tibble with one row per pick
#' @examples
#' draft_tracker <- get_draft_tracker()
#' @export

get_draft_tracker <- function() {
  out <- nhl_api(
    path='draft-tracker/picks/now',
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out$picks))
}

#' Get draft information for all seasons
#' 
#' @return tibble with one row per season
#' @examples
#' draft_info <- get_draft_information()
#' @export

get_draft_information <- function() {
  out <- nhl_api(
    path='draft',
    query=list(limit=-1),
    type=2
  )
  return(tibble::as_tibble(out$data))
}
