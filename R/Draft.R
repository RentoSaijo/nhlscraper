#' Get all the drafts
#' 
#' `ns_drafts()` retrieves information on each draft, including but not 
#' limited to their year, type, venue, minimum and maximum player ages, and 
#' number of rounds and picks.
#' 
#' @return data.frame with one row per draft
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

#' Get all the draft picks
#' 
#' `ns_draft_picks()` retrieves information on each selection, including but 
#' not limited to their player ID, name, draft year, overall number, 
#' bio-metrics, and the pick's team history.
#' 
#' @return data.frame with one row per pick
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_draft_picks <- ns_draft_picks()}
#' @export

ns_draft_picks <- function() {
  nhl_api(
    path = 'draft',
    type = 'r'
  )$data
}

#' Get all the expansion drafts
#' 
#' `ns_expansion_drafts()` retrieves information on ...
#' 
#' @return data.frame with one row per pick
#' @examples
#' all_expansion_drafts <- ns_expansion_drafts()
#' @export

ns_expansion_drafts <- function() {
  nhl_api(
    path = 'expansion-draft-rules',
    type = 'r'
  )$data
}

#' Get all the expansion draft picks
#' 
#' `ns_expansion_draft_picks()` retrieves information on ...
#' 
#' @return data.frame with one row per pick
#' @examples
#' all_expansion_draft_picks <- ns_expansion_draft_picks()
#' @export

ns_expansion_draft_picks <- function() {
  nhl_api(
    path = 'expansion-draft-picks',
    type = 'r'
  )$data
}

#' Get all the draft prospects
#' 
#' `ns_draft_prospects()` retrieves information on ...
#' 
#' @return data.frame with one row per prospect
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_draft_prospects <- ns_draft_prospects()}
#' @export

ns_draft_prospects <- function() {
  nhl_api(
    path = 'draft-prospect',
    type = 'r'
  )$data
}

#' Get the draft rankings of a class for a category
#' 
#' `ns_draft_rankings()` retrieves information on each prospect for a given set 
#' of `year` and `player_type`, including but not limited to their name, 
#' midterm and final ranks, position, bio-metrics, and birth date and location.
#' 
#' @param class integer in YYYY (e.g., 2025)
#' @param category integer in 1:4 (where 1 = North American Skaters, 
#' 2 = International Skaters, 3 = North American Goalies, and 4 = International 
#' Goalies) OR character in 'NAS'/'NA Skaters'/'North American Skaters', 
#' 'INTLS'/'INTL Skaters'/'International Skaters', 
#' 'NAG'/'NA Goalies'/'North American Goalies',
#' 'INTLG'/'INTL Goalies'/'International Goalies'
#' @return data.frame with one row per player
#' @examples
#' draft_rankings_NA_Skaters_2025 <- ns_draft_rankings(
#'   class    = 2025, 
#'   category = 1
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the real-time draft tracker
#' 
#' `ns_draft_tracker()` retrieves information on the latest draft, including 
#' but not limited to each pick's team ID, name, and overall number and 
#' selected player's name and position.
#' 
#' @return data.frame with one row per pick
#' @examples
#' draft_tracker <- ns_draft_tracker()
#' @export

ns_draft_tracker <- function() {
  nhl_api(
    path = 'v1/draft-tracker/picks/now',
    type = 'w'
  )$picks
}
