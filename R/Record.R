#' Get all franchises' all-time records versus other franchises
#' 
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @return tibble with one row per franchise versus franchise
#' @examples
#' franchise_vs_franchise <- get_franchise_vs_franchise()
#' @export

get_franchise_vs_franchise <- function(game_type=2) {
  p <- 'all-time-record-vs-franchise'
  if (game_type==3) {
    p <- 'playoff-franchise-vs-franchise'
  }
  out <- nhl_api(
    path=p,
    type=3
  )
  return(tibble::as_tibble(out$data))
}
