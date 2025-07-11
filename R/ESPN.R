#' Get ESPN transactions by season
#' 
#' @param season integer Season in YYYY
#' @return tibble with one row per transaction
#' @examples
#' espn_transactions_2024 <- get_espn_transactions(2024)
#' @export

get_espn_transactions <- function(season=get_season_now()$seasonId%/%10000) {
  page <- 1
  all_transactions <- list()
  repeat {
    out <- espn_api(
      path='transactions',
      query=list(limit=1000, season=season, page=page),
      type=1
    )
    df <- tibble::as_tibble(out$transactions)
    all_transactions[[page+1]] <- df
    if (nrow(df) < 1000) {
      break
    }
    page <- page+1
  }
  return(dplyr::bind_rows(all_transactions))
}

#' Get ESPN injury reports as of now
#' 
#' @return nested tibble with one row per team and one row per player
#' @examples
#' espn_injuries_now <- get_espn_injuries()
#' @export

get_espn_injuries <- function() {
  out <- espn_api(
    path='injuries',
    query=list(limit=1000),
    type=1
  )
  return(tibble::as_tibble(out$injuries))
}

#' Get ESPN futures by season
#' 
#' @param season integer Season in YYYY
#' @return tibble with one row per future
#' @examples
#' espn_futures_2024 <- get_espn_futures(2024)
#' @export

get_espn_futures <- function(season=get_season_now()$seasonId%/%10000) {
  out <- espn_api(
    path=sprintf('seasons/%s/futures', season),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}

#' Get ESPN events (games) by season
#' 
#' @param season integer Season in YYYY
#' @return tibble with one row per event (game)
#' @examples
#' ESPN_events_2024 <- get_espn_events(2024)
#' @export

get_espn_events <- function(season=get_season_now()$seasonId%/%10000) {
  page <- 1
  all_events <- list()
  repeat {
    out <- espn_api(
      path='events',
      query=list(
        lang='en',
        region='us',
        limit=1000, 
        page=page,
        dates=season
      ),
      type=2
    )
    df <- tibble::as_tibble(out$items)
    all_events[[page+1]] <- df
    if (nrow(df) < 1000) {
      break
    }
    page <- page+1
  }
  return(dplyr::bind_rows(all_events))
}
