#' Access all the drafts
#'
#' `drafts()` retrieves all the drafts as a `data.frame` where each row represents draft and includes detail on venue/location geography and regional metadata.
#'
#' @returns data.frame with one row per draft
#' @examples
#' all_drafts <- drafts()
#' @export

drafts <- function() {
  tryCatch({
    master <- nhl_api(
      path = 'draft-master',
      type = 'r'
    )$data
    rounds <- nhl_api(
      path = 'en/draft',
      type = 's'
    )$data
    rounds$id        <- NULL
    drafts           <- merge(master, rounds, by = 'draftYear')
    column_to_move   <- 'id'
    other_columns    <- setdiff(names(drafts), column_to_move)
    new_column_order <- c(column_to_move, other_columns)
    drafts <- drafts[, new_column_order]
    names(drafts)[names(drafts) == 'id']   <- 'draftId'
    drafts
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the draft picks
#'
#' `draft_picks()` retrieves all the draft picks as a `data.frame` where each row represents pick and includes detail on team identity, affiliation, and matchup-side context plus player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per pick
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_draft_picks <- draft_picks()}
#' @export

draft_picks <- function() {
  tryCatch({
    picks <- nhl_api(
      path = 'draft',
      type = 'r'
    )$data
    picks <- picks[order(picks$draftYear), ]
    names(picks)[names(picks) == 'id'] <- 'draftPickId'
    picks
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the draft prospects
#'
#' `draft_prospects()` retrieves all the draft prospects as a `data.frame` where each row represents player and includes detail on player identity, role, handedness, and biographical profile plus broadcast carriage, media availability, and viewing-link metadata.
#'
#' @returns data.frame with one row per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_prospects <- draft_prospects()}
#' @export

draft_prospects <- function() {
  tryCatch({
    prospects <- nhl_api(
      path = 'draft-prospect',
      type = 'r'
    )$data
    prospects <- prospects[order(prospects$firstName, prospects$lastName), ]
    names(prospects)[names(prospects) == 'id']       <- 'prospectId'
    names(prospects)[names(prospects) == 'playerid'] <- 'playerId'
    prospects
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the draft rankings for a class and category
#'
#' `draft_rankings()` retrieves the draft rankings for a class and category as a `data.frame` where each row represents player and includes detail on player identity, role, handedness, and biographical profile plus draft-board context, scouting background, and pick/round progression.
#'
#' @param class integer in YYYY (e.g., 2017); see [drafts()] for reference
#' @param category integer in 1:4 (where 1 = North American Skaters, 
#' 2 = International Skaters, 3 = North American Goalies, and 4 = International 
#' Goalies) OR character of 'NAS'/'NA Skaters'/'North American Skaters', 
#' 'INTLS'/'INTL Skaters'/'International Skaters', 
#' 'NAG'/'NA Goalies'/'North American Goalies',
#' 'INTLG'/'INTL Goalies'/'International Goalies'
#'
#' @returns data.frame with one row per player
#' @examples
#' draft_rankings_INTL_Skaters_2017 <- draft_rankings(
#'   class    = 2017, 
#'   category = 2
#' )
#' @export

draft_rankings <- function(
  class    = season_now() %% 1e4,
  category = 1
) {
  tryCatch(
    expr = {
      category <- switch(
        tolower(category),
        `1`                      = 1,
        nas                      = 1,
        `na skaters`             = 1,
        `north american skaters` = 1,
        `2`                      = 2,
        intls                    = 2,
        `intl skaters`           = 2,
        `international skaters`  = 2,
        `3`                      = 3,
        nag                      = 3,
        `na goalies`             = 3,
        `north american goalies` = 3,
        `4`                      = 4,
        intlg                    = 4,
        `intl goalies`           = 4,
        `international goalies`  = 4
      )
      nhl_api(
        path = sprintf('v1/draft/rankings/%s/%s', class, category),
        type = 'w'
      )$rankings
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the draft combine reports
#'
#' `combine_reports()` retrieves the draft combine reports as a `data.frame` where each row represents player and includes detail on player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per player
#' @examples
#' combine_reports <- combine_reports()
#' @export

combine_reports <- function() {
  tryCatch({
    reports    <- nhl_api(
      path = 'combine',
      type = 'r'
    )$data
    reports$id <- NULL
    reports[order(reports$draftYear, reports$event), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the draft lottery odds
#'
#' `lottery_odds()` retrieves the draft lottery odds as a `data.frame` where each row represents draft lottery and includes detail on draft-cycle evaluation, ranking, and selection tracking detail.
#'
#' @returns data.frame with one row per draft lottery
#' @examples
#' lottery_odds <- lottery_odds()
#' @export

lottery_odds <- function() {
  tryCatch({
    lotteries <- nhl_api(
      path = 'draft-lottery-odds',
      type = 'r'
    )$data
    lotteries <- lotteries[order(lotteries$draftYear), ]
    names(lotteries)[names(lotteries) == 'id'] <- 'lotteryId'
    lotteries
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the real-time draft tracker
#'
#' `draft_tracker()` retrieves the real-time draft tracker as a `data.frame` where each row represents player and includes detail on team identity, affiliation, and matchup-side context, player identity, role, handedness, and biographical profile, and venue/location geography and regional metadata.
#'
#' @returns data.frame with one row per player
#' @examples
#' draft_tracker <- draft_tracker()
#' @export

draft_tracker <- function() {
  tryCatch({
    nhl_api(
      path = 'v1/draft-tracker/picks/now',
      type = 'w'
    )$picks
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the expansion drafts
#'
#' `expansion_drafts()` retrieves all the expansion drafts as a `data.frame` where each row represents expansion draft and includes detail on date/season filtering windows and chronological context plus reference definitions and rules-framework information.
#'
#' @returns data.frame with one row per expansion draft
#' @examples
#' all_expansion_drafts <- expansion_drafts()
#' @export

expansion_drafts <- function() {
  tryCatch({
    drafts    <- nhl_api(
      path = 'expansion-draft-rules',
      type = 'r'
    )$data
    drafts$id <- NULL
    drafts[order(drafts$seasonId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the expansion draft picks
#'
#' `expansion_draft_picks()` retrieves all the expansion draft picks as a `data.frame` where each row represents pick and includes detail on date/season filtering windows and chronological context plus team identity, affiliation, and matchup-side context.
#'
#' @returns data.frame with one row per pick
#' @examples
#' all_expansion_draft_picks <- expansion_draft_picks()
#' @export

expansion_draft_picks <- function() {
  tryCatch({
    drafts    <- nhl_api(
      path = 'expansion-draft-picks',
      type = 'r'
    )$data
    drafts$id <- NULL
    drafts[order(drafts$seasonId, drafts$teamId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
