#' Access all the coaches
#' 
#' `ns_coaches()` scrapes information on all the coaches.
#' 
#' @returns data.frame with one row per coach
#' @examples
#' all_coaches <- ns_coaches()
#' @export

ns_coaches <- function() {
  nhl_api(
    path = 'coach',
    type = 'r'
  )$data
}

#' Access the career statistics for all the coaches
#' 
#' `ns_coach_career_statistics()` scrapes the career results for all the coaches
#' 
#' @returns data.frame with one row per coach
#' @examples
#' coach_career_stats <- ns_coach_career_statistics()
#' @export

ns_coach_career_statistics <- function() {
  results <- nhl_api(
    path = 'coach-career-records-regular-plus-playoffs',
    type = 'r'
  )$data
  results$id <- NULL
  results[order(results$coachId), ]
}

#' @rdname ns_coach_career_statistics
#' @export
ns_coach_career_stats <- function() {
  ns_coach_career_statistics()
}

#' Access the statistics for all the coaches by franchise and game type
#' 
#' `ns_coach_franchise_statistics()` retrieves information on each coach ...
#' 
#' @returns data.frame with one row per franchise per coach per game type
#' @examples
#' coach_franchise_stats <- ns_coach_franchise_statistics()
#' @export

ns_coach_franchise_statistics <- function() {
  stats    <- nhl_api(
    path = 'coach-franchise-records',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$coachName, stats$firstCoachedDate), ]
}

#' @rdname ns_coach_franchise_statistics
#' @export
ns_coach_franchise_stats <- function() {
  ns_coach_franchise_statistics()
}
