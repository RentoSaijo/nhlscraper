#' Access all the awards
#' 
#' `ns_awards()` scrapes information on all the awards.
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

#' Access all the award winners/finalists
#' 
#' `ns_award_winners()` scrapes information on all the award winners/finalists.
#' 
#' @returns data.frame with one row per winner/finalist
#' @examples
#' all_award_winners <- ns_award_winners()
#' @export

ns_award_winners <- function() {
  winners    <- nhl_api(
    path = 'award-details',
    type = 'r'
  )$data
  winners$id <- NULL
  winners    <- winners[order(winners$status), ]
  winners    <- winners[order(winners$seasonId), ]
  winners[order(winners$trophyId), ]
}
