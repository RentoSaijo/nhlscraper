#' Get all franchises' teams' all-time totals
#' 
#' `get_franchise_team_totals()` retrieves information on each team, including but not limited to their ID, first and last seasons' IDs, and all-time statistics.
#' 
#' @return tibble with one row per team
#' @examples
#' all_franchise_team_totals <- get_franchise_team_totals()
#' @export

get_franchise_team_totals <- function() {
  out <- nhl_api(
    path='franchise-team-totals',
    type=3
  )
  return(tibble::as_tibble(out$data))
}

#' Get all franchises' all-time records versus other franchises
#' 
#' `get_franchise_vs_franchise()` retrieves information on each franchise versus another franchise, including but not limited to their IDs, game-type ID, and all-time statistics.
#' 
#' @return tibble with one row per franchise versus franchise
#' @examples
#' franchise_vs_franchise <- get_franchise_vs_franchise()
#' @export

get_franchise_vs_franchise <- function() {
  out <- nhl_api(
    path='all-time-record-vs-franchise',
    type=3
  )
  return(tibble::as_tibble(out$data))
}
