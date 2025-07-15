#' Get draft rankings by year and player-type
#' 
#' `get_draft_rankings()` retrieves information on each draft prospect for a specified `year` and `player_type`, including but not limited to their name, midterm and final ranks, position, bio-metrics, and birth date and location.
#' 
#' @param year integer in YYYY
#' @param player_type integer where 1=North American Skaters, 
#'                    2=International Skaters, 3=North American Goalies, 
#'                    and 4=International Goalies
#' @return tibble with one row per player
#' @examples
#' draft_rankings_2025_1 <- get_draft_rankings(year=2025, player_type=1)
#' @export

get_draft_rankings <- function(
    year=get_season_now()$seasonId%/%10000,
    player_type=1
  ) {
  out <- nhl_api(
    path=sprintf('draft/rankings/%s/%s', year, player_type),
    type=1
  )
  return(tibble::as_tibble(out$rankings))
}

#' Get all draft picks
#' 
#' `get_draft_picks()` retrieves information on each draft selection, including but not limited to their player ID, name, draft year, overall number, bio-metrics, and the pick's team history.
#' 
#' @return tibble with one row per pick
#' @examples
#' all_draft_picks <- get_draft_picks()
#' @export

get_draft_picks <- function() {
  out <- nhl_api(
    path='draft',
    type=3
  )
  return(tibble::as_tibble(out$data))
}

#' Get draft tracker as of now
#' 
#' `get_draft_tracker()` retrieves information on the latest draft, including but not limited to each pick's team ID, name, and overall number and selected player's name and position.
#' 
#' @return tibble with one row per pick
#' @examples
#' draft_tracker <- get_draft_tracker()
#' @export

get_draft_tracker <- function() {
  out <- nhl_api(
    path='draft-tracker/picks/now',
    type=1
  )
  return(tibble::as_tibble(out$picks))
}

#' Get all drafts
#' 
#' `get_drafts()` retrieves information on each draft, including but not limited to their year, type, venue, minimum and maximum player ages, and number of rounds and picks.
#' 
#' @importFrom magrittr %>%
#' @return tibble with one row per draft
#' @examples
#' all_drafts <- get_drafts()
#' @export

get_drafts <- function() {
  out <- nhl_api(
    path='draft',
    query=list(limit=-1),
    type=2
  )
  out <- out$data %>% 
    dplyr::select(-id)
  out2 <- nhl_api(
    path='draft-master',
    type=3
  )
  merged <- out2$data %>% 
    dplyr::left_join(out, by='draftYear')
  return(tibble::as_tibble(merged))
}
