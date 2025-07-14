#' Get all awards
#' 
#' `get_awards()` retrieves information about each award, including but not limited to their trophy ID, name, description, creation date, and image URL.
#' 
#' @return tibble with one row per award
#' @examples
#' all_awards <- get_awards()
#' @export

get_awards <- function() {
  out <- nhl_api(
    path='trophy',
    type=3
  )
  return(tibble::as_tibble(out$data))
}

#' Get all award winners/finalists
#' 
#' `get_award_winners()` retrieves information about each award winner or finalist, including but not limited to their player, trophy, and season IDs; name; and vote count. 
#' 
#' @return tibble with one row per winner/finalist
#' @examples
#' all_award_winners <- get_award_winners()
#' @export

get_award_winners <- function() {
  out <- nhl_api(
    path='award-details',
    type=3
  )
  return(tibble::as_tibble(out$data))
}
