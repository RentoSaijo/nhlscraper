#' Access all the officials
#' 
#' `ns_officials()` scrapes information on all the officials.
#' 
#' @returns data.frame with one row per official
#' @examples
#' all_officials <- ns_officials()
#' @export

ns_officials <- function() {
  nhl_api(
    path = 'officials',
    type = 'r'
  )$data
}
