#' Access all the franchises
#' 
#' `franchises()` scrapes all the franchises.
#'
#' @returns data.frame with one row per franchise
#' @examples
#' all_franchises <- franchises()
#' @export

franchises <- function() {
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
#' `franchise_statistics()` scrapes the all-time statistics for all the 
#' franchises by game type.
#' 
#' @returns data.frame with one row per franchise per game type
#' @examples
#' franchise_stats <- franchise_statistics()
#' @export

franchise_statistics <- function() {
  stats <- nhl_api(
    path = 'franchise-totals',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$franchiseId, stats$gameTypeId), ]
}

#' @rdname franchise_statistics
#' @export
franchise_stats <- function() {
  franchise_statistics()
}

#' Access the all-time statistics for all the franchises by team and game type
#' 
#' `franchise_team_statistics()` scrapes the all-time statistics for all the 
#' franchises by team and game type.
#' 
#' @returns data.frame with one row per team per franchise per game type
#' @examples
#' franchise_team_stats <- franchise_team_statistics()
#' @export

franchise_team_statistics <- function() {
  stats <- nhl_api(
    path = 'franchise-team-totals',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$franchiseId, stats$teamId, stats$gameTypeId), ]
}

#' @rdname franchise_team_statistics
#' @export
franchise_team_stats <- function() {
  franchise_team_statistics()
}

#' Access the statistics for all the franchises by season and game type
#' 
#' `franchise_season_statistics()` scrapes the statistics for all the 
#' franchises by season and game type.
#' 
#' @returns data.frame with one row per franchise per season per game type
#' @examples
#' # May take >5s, so skip.
#' \donttest{franchise_season_stats <- franchise_season_statistics()}
#' @export

franchise_season_statistics <- function() {
  stats <- nhl_api(
    path = 'franchise-season-results',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$franchiseId, stats$seasonId, stats$gameTypeId), ]
}

#' @rdname franchise_season_statistics
#' @export
franchise_season_stats <- function() {
  franchise_season_statistics()
}

#' Access the all-time statistics versus other franchises for all the 
#' franchises by game type
#' 
#' `franchise_versus_franchise()` scrapes the all-time statistics versus 
#' other franchises for all the franchises by game type.
#' 
#' @returns data.frame with one row per franchise per franchise per game type
#' @examples
#' # May take >5s, so skip.
#' \donttest{franchise_vs_franchise <- franchise_versus_franchise()}
#' @export

franchise_versus_franchise <- function() {
  versus <- nhl_api(
    path = 'all-time-record-vs-franchise',
    type = 'r'
  )$data
  versus$id <- NULL
  versus[order(
    versus$teamFranchiseId, 
    versus$teamId, 
    versus$opponentFranchiseId, 
    versus$opponentTeamId, 
    versus$gameTypeId
  ), ]
}

#' @rdname franchise_versus_franchise
#' @export
franchise_vs_franchise <- function() {
  franchise_versus_franchise()
}

#' Access the playoff series results for all the franchises by situation
#' 
#' `franchise_playoff_situational_results()` scrapes the playoff series 
#' results for all the franchises by situation.
#'
#' @returns data.frame with one row per franchise per situation
#' @examples
#' franchise_playoff_situational_results <- 
#'   franchise_playoff_situational_results()
#' @export

franchise_playoff_situational_results <- function() {
  results    <- nhl_api(
    path = 'series-situational-records',
    type = 'r'
  )$data
  results$id <- NULL
  results[order(results$franchiseId, results$seriesSituation), ]
}
