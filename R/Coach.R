#' Access all the coaches
#' 
#' `coaches()` scrapes all the coaches.
#' 
#' @returns data.frame with one row per coach
#' @examples
#' all_coaches <- coaches()
#' @export

coaches <- function() {
  tryCatch({
    nhl_api(
      path = 'coach',
      type = 'r'
    )$data
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the career statistics for all the coaches
#' 
#' `coach_career_statistics()` scrapes the career results for all the coaches.
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
    results[order(results$coachId), ]
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
#' `coach_franchise_statistics()` scrapes the statistics for all the coaches by 
#' franchise and game type.
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
    stats[order(stats$coachName, stats$firstCoachedDate), ]
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
