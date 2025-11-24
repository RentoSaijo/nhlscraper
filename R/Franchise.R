#' Get all the franchises
#' 
#' `ns_franchises()` retrieves information on each franchise, including but 
#' not limited to their ID; first and last seasons' IDs; captain, coach, and 
#' general manager histories; and retired numbers.
#' 
#' @return data.frame with one row per franchise
#' @examples
#' all_franchises <- ns_franchises()
#' @export

ns_franchises <- function() {
  franchises <- nhl_api(
    path = 'franchise',
    type = 'r'
  )$data
  details    <- nhl_api(
    path = 'franchise-detail',
    type = 'r'
  )$data
  details$firstSeasonId    <- NULL
  details$mostRecentTeamId <- NULL
  details$teamAbbrev       <- NULL
  merge(franchises[order(franchises$id), ], details, by = 'id')
}

#' Get all the franchises' all-time records
#' 
#' `ns_franchise_records()` retrieves information on each team, including 
#' but not limited to their ID, first and last seasons' IDs, and all-time 
#' statistics.
#' 
#' @return data.frame with one row per franchise
#' @examples
#' franchise_records <- ns_franchise_records()
#' @export

ns_franchise_records <- function() {
  nhl_api(
    path = 'franchise-totals',
    type = 'r'
  )$data
}

#' Get all the franchises' teams' all-time records
#' 
#' `ns_franchise_team_records()` retrieves information on each team, including 
#' but not limited to their ID, first and last seasons' IDs, and all-time 
#' statistics.
#' 
#' @return data.frame with one row per franchise's team
#' @examples
#' franchise_team_records <- ns_franchise_team_records()
#' @export

ns_franchise_team_records <- function() {
  nhl_api(
    path = 'franchise-team-totals',
    type = 'r'
  )$data
}

#' Get the season-by-season results for all the franchises
#' 
#' `ns_franchise_season_by_season()` retrieves information on each 
#' franchise's season, including but not limited to their ID, decision, final 
#' playoff round, and statistics.
#' 
#' @return data.frame with one row per franchise's season
#' @examples
#' sbs_all_franchises <- ns_franchise_season_by_season()
#' @export

ns_franchise_season_by_season <- function() {
  nhl_api(
    path = 'franchise-season-results',
    type = 'r'
  )$data
}

#' @rdname ns_franchise_season_by_season
#' @export
ns_franchise_sbs <- function() {
  ns_franchise_season_by_season()
}

#' Get all the franchises' all-time records versus other franchises
#' 
#' `ns_franchise_versus_franchise()` retrieves information on each franchise 
#' versus another franchise, including but not limited to their IDs, game-type 
#' ID, and all-time statistics.
#' 
#' @return data.frame with one row per franchise versus another franchise
#' @examples
#' franchise_vs_franchise <- ns_franchise_versus_franchise()
#' @export

ns_franchise_versus_franchise <- function() {
  franchises <- nhl_api(
    path = 'all-time-record-vs-franchise',
    type = 'r'
  )$data
}

#' @rdname ns_franchise_versus_franchise
#' @export
ns_franchise_vs_franchise <- function() {
  ns_franchise_versus_franchise()
}
