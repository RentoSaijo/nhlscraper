#' Get all the drafts
#' 
#' `get_drafts()` is defunct. Use [ns_drafts()] instead.
#' 
#' @export

get_drafts <- function() {
  .Defunct(
    new     = 'ns_drafts()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_drafts()` is defunct.',
      'Use `ns_drafts()` instead.'
    )
  )
}

#' Get all the draft picks
#' 
#' `get_draft_picks()` is deprecated. Use [ns_draft_picks()] instead.
#' 
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

#' Get the draft rankings of a year for a player type
#' 
#' `get_draft_rankings()` is deprecated. Use [ns_draft_rankings()] instead.
#' 
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

#' Get the real-time draft tracker
#' 
#' `get_draft_tracker()` is deprecated. Use [ns_draft_tracker()] instead.
#' 
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
