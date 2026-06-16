#' Access all the coaches
#'
#' `coaches()` returns the records-site coach registry with one row per coach
#' and normalized coach IDs, names, and birth fields.
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
    names(coaches)[names(coaches) == 'id']                <- 'coachId'
    names(coaches)[names(coaches) == 'firstName']         <- 'coachFirstName'
    names(coaches)[names(coaches) == 'fullName']          <- 'coachFullName'
    names(coaches)[names(coaches) == 'lastName']          <- 'coachLastName'
    names(coaches)[names(coaches) == 'birthCountry3code'] <- 'birthCountryTriCode'
    coaches
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the career statistics for all the coaches
#'
#' `coach_career_statistics()` returns regular-season plus playoff career
#' coaching records with one row per coach.
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
    names(results) <- normalize_team_abbrev_cols(names(results))
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
#' `coach_franchise_statistics()` returns coach records by franchise and game
#' type, with one row per coach/franchise/game-type stint.
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
    names(stats)[names(stats) == 'firstName']   <- 'coachFirstName'
    names(stats)[names(stats) == 'lastName']    <- 'coachLastName'
    names(stats) <- normalize_team_abbrev_cols(names(stats))
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
