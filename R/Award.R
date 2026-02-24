#' Access all the awards
#'
#' `awards()` retrieves all the awards as a `data.frame` where each row represents award and includes detail on recognition, leaderboard, and milestone-watch context.
#'
#' @returns data.frame with one row per award
#' @examples
#' all_awards <- awards()
#' @export

awards <- function() {
  tryCatch({
    trophies <- nhl_api(
      path = 'trophy',
      type = 'r'
    )$data
    names(trophies)[names(trophies) == 'id'] <- 'trophyId'
    trophies
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the award winners/finalists
#'
#' `award_winners()` retrieves all the award winners/finalists as a `data.frame` where each row represents winner/finalist and includes detail on date/season filtering windows and chronological context, team identity, affiliation, and matchup-side context, and player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per winner/finalist
#' @examples
#' all_award_winners <- award_winners()
#' @export

award_winners <- function() {
  tryCatch({
    winners    <- nhl_api(
      path = 'award-details',
      type = 'r'
    )$data
    winners$id <- NULL
    winners[order(winners$trophyId, winners$seasonId, winners$status), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
