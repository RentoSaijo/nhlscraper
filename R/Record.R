#' Get the attendance for all the seasons
#' 
#' `ns_attendance()` retrieves information on each season, including but not 
#' limited to their ID and regular and playoff attendance.
#' 
#' @return data.frame with one row per season
#' @examples
#' all_attendance <- ns_attendance()
#' @export

ns_attendance <- function() {
  nhl_api(
    path = 'attendance',
    type = 'r'
  )$data
}
