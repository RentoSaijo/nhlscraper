#' Access all the drafts
#' 
#' `get_drafts()` is deprecated. Use [ns_drafts()] instead.
#'
#' @returns data.frame with one row per draft
#' @export

get_drafts <- function() {
  .Deprecated(
    new     = 'ns_drafts()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_drafts()` is deprecated.',
      'Use `ns_drafts()` instead.'
    )
  )
  ns_drafts()
}

#' Access all the draft picks
#' 
#' `get_draft_picks()` is deprecated. Use [ns_draft_picks()] instead.
#' 
#' @returns data.frame with one row per pick
#' @export

get_draft_picks <- function() {
  .Deprecated(
    new     = 'ns_draft_picks()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_draft_picks()` is deprecated.',
      'Use `ns_draft_picks()` instead.'
    )
  )
  ns_draft_picks()
}

#' Access the draft rankings for a year and player type
#' 
#' `get_draft_rankings()` is deprecated. Use [ns_draft_rankings()] instead.
#' 
#' @param year integer in YYYY (e.g., 2017); see [ns_drafts()] for reference
#' @param player_type integer in 1:4 (where 1 = North American Skaters, 
#' 2 = International Skaters, 3 = North American Goalies, and 4 = International 
#' Goalies)
#' @returns data.frame with one row per player
#' @export

get_draft_rankings <- function(
  year        = ns_season() %/% 1e4,
  player_type = 1
) {
  .Deprecated(
    new     = 'ns_draft_rankings()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_draft_rankings()` is deprecated.',
      'Use `ns_draft_rankings()` instead.'
    )
  )
  ns_draft_rankings(year, player_type)
}

#' Access the real-time draft tracker
#' 
#' `get_draft_tracker()` is deprecated. Use [ns_draft_tracker()] instead.
#' 
#' @returns data.frame with one row per player
#' @export

get_draft_tracker <- function() {
  .Deprecated(
    new     = 'ns_draft_tracker()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_draft_tracker()` is deprecated.',
      'Use `ns_draft_tracker()` instead.'
    )
  )
  ns_draft_tracker()
}
