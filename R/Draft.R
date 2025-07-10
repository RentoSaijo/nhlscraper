#' Get draft rankings by year and player-type
#' 
#' @param year integer Year in YYYY
#' @param player_type integer Player-type where 1=NA Skaters, 2=Int. Skaters, 
#'                    3=NA Goalies, and 4=Int. Goalies
#' @return tibble with one row per player
#' @examples
#' draft_rankings_2025 <- get_draft_rankings(year=2025)
#' @export

get_draft_rankings <- function(
    year=get_season_now()$seasonId%%10000,
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
