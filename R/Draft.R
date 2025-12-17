#' Access all the drafts
#' 
#' `drafts()` scrapes all the drafts.
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
    drafts[, new_column_order]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the draft picks
#' 
#' `draft_picks()` scrapes all the draft picks.
#' 
#' @returns data.frame with one row per pick
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_draft_picks <- draft_picks()}
#' @export

draft_picks <- function() {
  tryCatch({
    picks    <- nhl_api(
      path = 'draft',
      type = 'r'
    )$data
    picks$id <- NULL
    picks[order(picks$draftYear), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access all the draft prospects
#' 
#' `draft_prospects()` scrapes all the draft prospects.
#' 
#' @returns data.frame with one row per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_prospects <- draft_prospects()}
#' @export

draft_prospects <- function() {
  tryCatch({
    prospects    <- nhl_api(
      path = 'draft-prospect',
      type = 'r'
    )$data
    prospects$id <- NULL
    prospects[order(prospects$firstName, prospects$lastName), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the draft rankings for a class and category
#' 
#' `draft_rankings()` scrapes the draft rankings for a given set of `class` 
#' and `category`.
#' 
#' @param class integer in YYYY (e.g., 2017); see [drafts()] for reference
#' @param category integer in 1:4 (where 1 = North American Skaters, 
#' 2 = International Skaters, 3 = North American Goalies, and 4 = International 
#' Goalies) OR character of 'NAS'/'NA Skaters'/'North American Skaters', 
#' 'INTLS'/'INTL Skaters'/'International Skaters', 
#' 'NAG'/'NA Goalies'/'North American Goalies',
#' 'INTLG'/'INTL Goalies'/'International Goalies'
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
        NAS                      = 1,
        `NA Skaters`             = 1,
        `North American Skaters` = 1,
        `2`                      = 2,
        INTLS                    = 2,
        `INTL Skaters`           = 2,
        `International Skaters`  = 2,
        `3`                      = 3,
        NAG                      = 3,
        `NA Goalies`             = 3,
        `North American Goalies` = 3,
        `4`                      = 4,
        INTLG                    = 4,
        `INTL Goalies`           = 4,
        `International Goalies`  = 4
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
#' `combine_reports()` scrapes the draft combine reports.
#' 
#' @returns data.frame with one row per player
#' @examples
#' combine_reports <- combine_reports()
#' @export

combine_reports <- function() {
  tryCatch({
    combine    <- nhl_api(
      path = 'combine',
      type = 'r'
    )$data
    combine$id <- NULL
    combine[order(combine$draftYear, combine$event), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the draft lottery odds
#' 
#' `lottery_odds()` scrapes the draft lottery odds.
#' 
#' @returns data.frame with one row per draft lottery
#' @examples
#' lottery_odds <- lottery_odds()
#' @export

lottery_odds <- function() {
  tryCatch({
    lotteries    <- nhl_api(
      path = 'draft-lottery-odds',
      type = 'r'
    )$data
    lotteries$id <- NULL
    lotteries[order(lotteries$draftYear), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the real-time draft tracker
#' 
#' `draft_tracker()` scrapes the real-time draft tracker.
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
#' `expansion_drafts()` scrapes all the expansion drafts.
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
#' `expansion_draft_picks()` scrapes all the expansion draft picks.
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
