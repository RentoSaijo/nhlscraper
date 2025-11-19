#' Get all the franchises
#' 
#' `ns_franchises()` retrieves information on each franchise, including but 
#' not limited to their ID; first and last seasons' IDs; captain, coach, and 
#' general manager histories; and retired numbers.
#' 
#' @return data.frame with one row per franchise
#' @examples
#' all_franchises <- ns_franchises()
#' @export

ns_franchises <- function() {
  franchises <- nhl_api(
    path = 'en/franchise',
    type = 's'
  )$data
  franchises[order(franchises$id), ]
}
