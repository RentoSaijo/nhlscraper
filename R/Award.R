#' Get all the awards
#' 
#' `ns_awards()` retrieves information on each award, including but not 
#' limited to their trophy ID, name, description, creation date, and image URL.
#' 
#' @returns data.frame with one row per award
#' @examples
#' all_awards <- ns_awards()
#' @export

ns_awards <- function() {
  nhl_api(
    path = 'trophy',
    type = 'r'
  )$data
}

#' Get all the award winners/finalists
#' 
#' `ns_award_winners()` retrieves information on each award winner or 
#' finalist, including but not limited to their player, trophy, and season IDs; 
#' name; and vote count. 
#' 
#' @returns data.frame with one row per winner/finalist
#' @examples
#' all_award_winners <- ns_award_winners()
#' @export

ns_award_winners <- function() {
  nhl_api(
    path = 'award-details',
    type = 'r'
  )$data
}
