# Award Functions ---------------------------------------------------------

#' Access all the awards
#'
#' `awards()` returns the records-site trophy catalog with one row per award
#' and normalized trophy IDs, names, and short names.
#'
#' @returns data.frame with one row per award
#' @examples
#' all_awards <- awards()
#' @export
awards <- function() {
  tryCatch({
    trophies <- .nhl_api(
      path = 'trophy',
      type = 'r'
    )$data
    names(trophies)[names(trophies) == 'id']        <- 'trophyId'
    names(trophies)[names(trophies) == 'name']      <- 'trophyName'
    names(trophies)[names(trophies) == 'shortName'] <- 'trophyShortName'
    trophies
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the award winners/finalists
#'
#' `award_winners()` returns historical trophy winners and finalists with one
#' row per player/season/status entry.
#'
#' @returns data.frame with one row per winner/finalist
#' @examples
#' all_award_winners <- award_winners()
#' @export
award_winners <- function() {
  tryCatch({
    winners    <- .nhl_api(
      path = 'award-details',
      type = 'r'
    )$data
    winners$id <- NULL
    names(winners)[names(winners) == 'fullName'] <- 'playerFullName'
    winners[order(winners$trophyId, winners$seasonId, winners$status), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
