#' Access all the franchises
#' 
#' `ns_franchises()` scrapes information on all the franchises.
#'
#' @returns data.frame with one row per franchise
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

#' Access the all-time statistics for all the franchises by game type
#' 
#' `ns_franchise_statistics()` scrapes the all-time statistics for all the 
#' franchises by game type.
#' 
#' @returns data.frame with one row per franchise per game type
#' @examples
#' franchise_stats <- ns_franchise_statistics()
#' @export

ns_franchise_statistics <- function() {
  stats <- nhl_api(
    path = 'franchise-totals',
    type = 'r'
  )$data
  stats$id <- NULL
  stats    <- stats[order(stats$gameTypeId), ]
  stats[order(stats$franchiseId), ]
}

#' @rdname ns_franchise_statistics
#' @export
ns_franchise_stats <- function() {
  ns_franchise_statistics()
}

#' Access the all-time statistics for all the franchises by team and game type
#' 
#' `ns_franchise_team_statistics()` scrapes the all-time statistics for all the 
#' franchises by team and game type.
#' 
#' @returns data.frame with one row per team per franchise per game type
#' @examples
#' franchise_team_stats <- ns_franchise_team_statistics()
#' @export

ns_franchise_team_statistics <- function() {
  stats <- nhl_api(
    path = 'franchise-team-totals',
    type = 'r'
  )$data
  stats$id <- NULL
  stats    <- stats[order(stats$gameTypeId), ]
  stats    <- stats[order(stats$franchiseId), ]
  stats[order(stats$teamId), ]
}

#' @rdname ns_franchise_team_statistics
#' @export
ns_franchise_team_stats <- function() {
  ns_franchise_team_statistics()
}

#' Access the statistics for all the franchises by season and game type
#' 
#' `ns_franchise_season_statistics()` scrapes the statistics for all the 
#' franchises by season and game type.
#' 
#' @returns data.frame with one row per franchise per season per game type
#' @examples
#' # This may take >5s, so skip.
#' \donttest{franchise_season_stats <- ns_franchise_season_statistics()}
#' @export

ns_franchise_season_statistics <- function() {
  stats <- nhl_api(
    path = 'franchise-season-results',
    type = 'r'
  )$data
  stats$id <- NULL
  stats    <- stats[order(stats$gameTypeId), ]
  stats    <- stats[order(stats$seasonId), ]
  stats[order(stats$franchiseId), ]
}

#' @rdname ns_franchise_season_statistics
#' @export
ns_franchise_season_stats <- function() {
  ns_franchise_season_statistics()
}

#' Access the all-time statistics versus other franchises for all the 
#' franchises by game type
#' 
#' `ns_franchise_versus_franchise()` scrapes the all-time statistics versus 
#' other franchises for all the franchises by game type.
#' 
#' @returns data.frame with one row per franchise per franchise per game type
#' @examples
#' # This may take >5s, so skip.
#' \donttest{franchise_vs_franchise <- ns_franchise_versus_franchise()}
#' @export

ns_franchise_versus_franchise <- function() {
  versus <- nhl_api(
    path = 'all-time-record-vs-franchise',
    type = 'r'
  )$data
  versus$id <- NULL
  versus    <- versus[order(versus$gameTypeId), ]
  versus    <- versus[order(versus$opponentTeamId), ]
  versus    <- versus[order(versus$opponentFranchiseId), ]
  versus    <- versus[order(versus$teamId), ]
  versus[order(versus$teamFranchiseId), ]
}

#' @rdname ns_franchise_versus_franchise
#' @export
ns_franchise_vs_franchise <- function() {
  ns_franchise_versus_franchise()
}
