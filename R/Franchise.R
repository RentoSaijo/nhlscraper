#' Access all the franchises
#'
#' `franchises()` retrieves all the franchises as a `data.frame` where each row represents franchise and includes detail on team identity, affiliation, and matchup-side context.
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
#' `franchise_statistics()` retrieves the all-time statistics for all the franchises by game type as a `data.frame` where each row represents franchise per game type and includes detail on date/season filtering windows and chronological context, team identity, affiliation, and matchup-side context, and production, workload, efficiency, and result-level performance outcomes.
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
#' `franchise_team_statistics()` retrieves the all-time statistics for all the franchises by team and game type as a `data.frame` where each row represents team per franchise per game type and includes detail on date/season filtering windows and chronological context, team identity, affiliation, and matchup-side context, and production, workload, efficiency, and result-level performance outcomes.
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
#' `franchise_season_statistics()` retrieves the statistics for all the franchises by season and game type as a `data.frame` where each row represents franchise per season per game type and includes detail on date/season filtering windows and chronological context, team identity, affiliation, and matchup-side context, and production, workload, efficiency, and result-level performance outcomes.
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
#' `franchise_versus_franchise()` retrieves the all-time statistics versus other franchises for all the franchises by game type as a `data.frame` where each row represents franchise per franchise per game type and includes detail on date/season filtering windows and chronological context plus team identity, affiliation, and matchup-side context.
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
#' `franchise_playoff_situational_results()` retrieves the playoff series results for all the franchises by situation as a `data.frame` where each row represents franchise per situation and includes detail on team identity, affiliation, and matchup-side context.
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
