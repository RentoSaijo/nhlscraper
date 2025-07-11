#' Get ESPN transactions by start and end dates
#' 
#' @param start_date integer Start Date in YYYYMMDD
#' @param end_date integer End Date in YYYYMMDD
#' @return tibble with one row per transaction
#' @examples
#' ESPN_transactions_20242025 <- get_espn_transactions(start_date=20241004, end_date=20250624)
#' @export

get_espn_transactions <- function(start_date=20241004, end_date=20250624) {
  page <- 1
  all_transactions <- list()
  repeat {
    out <- espn_api(
      path='transactions',
      query=list(
        limit=1000, 
        dates=sprintf('%s-%s', start_date, end_date), 
        page=page
      ),
      type=1
    )
    df <- tibble::as_tibble(out$transactions)
    all_transactions[[page+1]] <- df
    if (nrow(df)<1000) {
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
#' ESPN_injuries_now <- get_espn_injuries()
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
#' ESPN_futures_20242025 <- get_espn_futures(2025)
#' @export

get_espn_futures <- function(season=get_season_now()$seasonId%%10000) {
  out <- espn_api(
    path=sprintf('seasons/%s/futures', season),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}
