#' Access all the franchises
#'
#' `franchises()` merges records-site franchise and franchise-detail metadata,
#' returning one row per franchise with normalized franchise/team identifiers
#' and names.
#'
#' @returns data.frame with one row per franchise
#' @examples
#' all_franchises <- franchises()
#' @export

franchises <- function() {
  tryCatch({
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
    franchises <- merge(franchises[order(franchises$id), ], details, by = 'id')
    names(franchises)[names(franchises) == 'id']       <- 'franchiseId'
    names(franchises)[names(franchises) == 'fullName'] <- 'franchiseFullName'
    names(franchises) <- normalize_team_abbrev_cols(names(franchises))
    franchises
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the all-time statistics for all the franchises by game type
#'
#' `franchise_statistics()` returns all-time franchise totals by game type,
#' including games, wins/losses, goals, points, and related aggregate fields.
#'
#' @returns data.frame with one row per franchise per game type
#' @examples
#' franchise_stats <- franchise_statistics()
#' @export

franchise_statistics <- function() {
  tryCatch({
    stats <- nhl_api(
      path = 'franchise-totals',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'teamAbbrev'] <- 'teamTriCode'
    names(stats) <- normalize_team_abbrev_cols(names(stats))
    stats[order(stats$franchiseId, stats$gameTypeId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname franchise_statistics
#' @export

franchise_stats <- function() {
  franchise_statistics()
}

#' Access the all-time statistics for all the franchises by team and game type
#'
#' `franchise_team_statistics()` returns all-time totals by franchise-era team
#' and game type, preserving separate rows for teams that share a franchise.
#'
#' @returns data.frame with one row per team per franchise per game type
#' @examples
#' franchise_team_stats <- franchise_team_statistics()
#' @export

franchise_team_statistics <- function() {
  tryCatch({
    stats <- nhl_api(
      path = 'franchise-team-totals',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'triCode'] <- 'teamTriCode'
    names(stats) <- normalize_team_abbrev_cols(names(stats))
    stats[order(stats$franchiseId, stats$teamId, stats$gameTypeId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname franchise_team_statistics
#' @export

franchise_team_stats <- function() {
  franchise_team_statistics()
}

#' Access the statistics for all the franchises by season and game type
#'
#' `franchise_season_statistics()` returns records-site franchise results by
#' season and game type, including team, standing, record, goals, and points
#' fields.
#'
#' @returns data.frame with one row per franchise per season per game type
#' @examples
#' # May take >5s, so skip.
#' \donttest{franchise_season_stats <- franchise_season_statistics()}
#' @export

franchise_season_statistics <- function() {
  tryCatch({
    stats <- nhl_api(
      path = 'franchise-season-results',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'triCode'] <- 'teamTriCode'
    names(stats) <- normalize_team_abbrev_cols(names(stats))
    stats[order(stats$franchiseId, stats$seasonId, stats$gameTypeId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname franchise_season_statistics
#' @export

franchise_season_stats <- function() {
  franchise_season_statistics()
}

#' Access the all-time statistics versus other franchises for all the 
#' franchises by game type
#'
#' `franchise_versus_franchise()` returns all-time head-to-head records by
#' franchise, opponent franchise, and game type.
#'
#' @returns data.frame with one row per franchise per franchise per game type
#' @examples
#' # May take >5s, so skip.
#' \donttest{franchise_vs_franchise <- franchise_versus_franchise()}
#' @export

franchise_versus_franchise <- function() {
  tryCatch({
    versus    <- nhl_api(
      path = 'all-time-record-vs-franchise',
      type = 'r'
    )$data
    versus$id <- NULL
    versus    <- versus[order(
      versus$teamFranchiseId, 
      versus$teamId, 
      versus$opponentFranchiseId, 
      versus$opponentTeamId, 
      versus$gameTypeId
    ), ]
    names(versus)[names(versus) == 'teamFranchiseId'] <- 'franchiseId'
    versus
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname franchise_versus_franchise
#' @export
franchise_vs_franchise <- function() {
  franchise_versus_franchise()
}

#' Access the playoff series results for all the franchises by situation
#'
#' `franchise_playoff_situational_results()` returns playoff series records by
#' franchise and series situation, such as leading or trailing a series.
#'
#' @returns data.frame with one row per franchise per situation
#' @examples
#' franchise_playoff_situational_results <- 
#'   franchise_playoff_situational_results()
#' @export

franchise_playoff_situational_results <- function() {
  tryCatch({
    results    <- nhl_api(
      path = 'series-situational-records',
      type = 'r'
    )$data
    results$id <- NULL
    results[order(results$franchiseId, results$seriesSituation), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
