#' Get all the coaches
#' 
#' `ns_coaches()` retrieves information on each coach ...
#' 
#' @return data.frame with one row per coach
#' @examples
#' all_coaches <- ns_coaches()
#' @export

ns_coaches <- function() {
  nhl_api(
    path = 'coach',
    type = 'r'
  )$data
}
