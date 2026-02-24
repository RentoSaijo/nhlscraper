#' Access all the coaches
#'
#' `coaches()` retrieves all the coaches as a `data.frame` where each row represents coach and includes detail on team identity, affiliation, and matchup-side context plus player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per coach
#' @examples
#' all_coaches <- coaches()
#' @export

coaches <- function() {
  tryCatch({
    coaches <- nhl_api(
      path = 'coach',
      type = 'r'
    )$data
    names(coaches)[names(coaches) == 'id'] <- 'coachId'
    coaches
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the career statistics for all the coaches
#'
#' `coach_career_statistics()` retrieves the career statistics for all the coaches as a `data.frame` where each row represents coach and includes detail on ranking movement, points pace, and division/conference position signals.
#'
#' @returns data.frame with one row per coach
#' @examples
#' coach_career_stats <- coach_career_statistics()
#' @export

coach_career_statistics <- function() {
  tryCatch({
    results <- nhl_api(
      path = 'coach-career-records-regular-plus-playoffs',
      type = 'r'
    )$data
    results$id <- NULL
    results    <- results[order(results$coachId), ]
    names(results)[names(results) == 'startSeason'] <- 'startSeasonId'
    names(results)[names(results) == 'endSeason']   <- 'endSeasonId'
    results
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname coach_career_statistics
#' @export

coach_career_stats <- function() {
  coach_career_statistics()
}

#' Access the statistics for all the coaches by franchise and game type
#'
#' `coach_franchise_statistics()` retrieves the statistics for all the coaches by franchise and game type as a `data.frame` where each row represents franchise per coach per game type and includes detail on date/season filtering windows and chronological context, team identity, affiliation, and matchup-side context, and player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per franchise per coach per game type
#' @examples
#' coach_franchise_stats <- coach_franchise_statistics()
#' @export

coach_franchise_statistics <- function() {
  tryCatch({
    stats    <- nhl_api(
      path = 'coach-franchise-records',
      type = 'r'
    )$data
    stats$id <- NULL
    stats    <- stats[order(stats$coachName, stats$firstCoachedDate), ]
    names(stats)[names(stats) == 'startSeason'] <- 'startSeasonId'
    names(stats)[names(stats) == 'endSeason']   <- 'endSeasonId'
    stats
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname coach_franchise_statistics
#' @export

coach_franchise_stats <- function() {
  coach_franchise_statistics()
}
