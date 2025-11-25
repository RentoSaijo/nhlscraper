#' Access all the drafts
#' 
#' `ns_drafts()` scrapes information on all the drafts.
#' 
#' @returns data.frame with one row per draft
#' @examples
#' all_drafts <- ns_drafts()
#' @export

ns_drafts <- function() {
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
}

#' Access all the draft picks
#' 
#' `ns_draft_picks()` scrapes information on all the draft picks.
#' 
#' @returns data.frame with one row per pick
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_draft_picks <- ns_draft_picks()}
#' @export

ns_draft_picks <- function() {
  picks    <- nhl_api(
    path = 'draft',
    type = 'r'
  )$data
  picks$id <- NULL
  picks[order(picks$draftYear), ]
}

#' Access all the draft prospects
#' 
#' `ns_draft_prospects()` scrapes information on all the draft prospects.
#' 
#' @returns data.frame with one row per player
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_draft_prospects <- ns_draft_prospects()}
#' @export

ns_draft_prospects <- function() {
  prospects    <- nhl_api(
    path = 'draft-prospect',
    type = 'r'
  )$data
  prospects$id <- NULL
  prospects[order(prospects$firstName, prospects$lastName), ]
}

#' Access the draft rankings for a class and category
#' 
#' `ns_draft_rankings()` scrapes the draft rankings for a given set of `class` 
#' and `category`.
#' 
#' @param class integer in YYYY (e.g., 2017); see [ns_drafts()] for reference
#' @param category integer in 1:4 (where 1 = North American Skaters, 
#' 2 = International Skaters, 3 = North American Goalies, and 4 = International 
#' Goalies) OR character of 'NAS'/'NA Skaters'/'North American Skaters', 
#' 'INTLS'/'INTL Skaters'/'International Skaters', 
#' 'NAG'/'NA Goalies'/'North American Goalies',
#' 'INTLG'/'INTL Goalies'/'International Goalies'
#' @returns data.frame with one row per player
#' @examples
#' draft_rankings_INTL_Skaters_2017 <- ns_draft_rankings(
#'   class    = 2017, 
#'   category = 2
#' )
#' @export

ns_draft_rankings <- function(
  class    = ns_season() %% 1e4,
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
#' `ns_combine_reports()` scrapes the draft combine reports.
#' 
#' @returns data.frame with one row per player
#' @examples
#' combine_reports <- ns_combine_reports()
#' @export

ns_combine_reports <- function() {
  combine    <- nhl_api(
    path = 'combine',
    type = 'r'
  )$data
  combine$id <- NULL
  combine <- combine[order(combine$event), ]
  combine[order(combine$draftYear), ]
}

#' Access the draft lottery odds
#' 
#' `ns_lottery_odds()` scrapes the draft lottery odds.
#' 
#' @returns data.frame with one row per draft lottery
#' @examples
#' lottery_odds <- ns_lottery_odds()
#' @export

ns_lottery_odds <- function() {
  lotteries    <- nhl_api(
    path = 'draft-lottery-odds',
    type = 'r'
  )$data
  lotteries$id <- NULL
  lotteries[order(lotteries$draftYear), ]
}

#' Access the real-time draft tracker
#' 
#' `ns_draft_tracker()` scrapes the real-time draft tracker.
#' 
#' @returns data.frame with one row per player
#' @examples
#' draft_tracker <- ns_draft_tracker()
#' @export

ns_draft_tracker <- function() {
  nhl_api(
    path = 'v1/draft-tracker/picks/now',
    type = 'w'
  )$picks
}

#' Access all the expansion drafts
#' 
#' `ns_expansion_drafts()` scrapes information on all the expansion drafts.
#' 
#' @returns data.frame with one row per expansion draft
#' @examples
#' all_expansion_drafts <- ns_expansion_drafts()
#' @export

ns_expansion_drafts <- function() {
  drafts    <- nhl_api(
    path = 'expansion-draft-rules',
    type = 'r'
  )$data
  drafts$id <- NULL
  drafts[order(drafts$seasonId), ]
}

#' Access all the expansion draft picks
#' 
#' `ns_expansion_draft_picks()` scrapes information on all the expansion draft 
#' picks
#' 
#' @returns data.frame with one row per pick
#' @examples
#' all_expansion_draft_picks <- ns_expansion_draft_picks()
#' @export

ns_expansion_draft_picks <- function() {
  drafts    <- nhl_api(
    path = 'expansion-draft-picks',
    type = 'r'
  )$data
  drafts$id <- NULL
  drafts    <- drafts[order(drafts$teamId), ]
  drafts[order(drafts$seasonId), ]
}
