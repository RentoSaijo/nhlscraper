#' Get all awards
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
#' @return tibble with one row per award
#' @examples
#' all_awards <- get_awards()
#' @export

get_award_winners <- function() {
  out <- nhl_api(
    path='award-details',
    type=3
  )
  return(tibble::as_tibble(out$data))
}
