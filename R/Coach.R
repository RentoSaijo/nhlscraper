#' Get all the coaches
#' 
#' `ns_coaches()` retrieves information on each coach ...
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

#' Get all the coaches' career records
#' 
#' `ns_coach_career_records()` retrieves information on each coach ...
#' 
#' @returns data.frame with one row per coach
#' @examples
#' coach_career_records <- ns_coach_career_records()
#' @export

ns_coach_career_records <- function() {
  nhl_api(
    path = 'coach-career-records-regular-plus-playoffs',
    type = 'r'
  )$data
}

#' Get all the coaches' franchise records by game type
#' 
#' `ns_coach_franchise_records()` retrieves information on each coach ...
#' 
#' @returns data.frame with one row per coach's franchise, separated by game type
#' @examples
#' coach_franchise_records <- ns_coach_franchise_records()
#' @export

ns_coach_franchise_records <- function() {
  nhl_api(
    path = 'coach-franchise-records',
    type = 'r'
  )$data
}
