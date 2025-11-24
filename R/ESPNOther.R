#' Get ESPN information on transactions for an interval of dates
#' 
#' `get_espn_transactions()` retrieves ESPN information on each transaction for 
#' an interval of dates bound by a given set of `start_date` and `end_date`, 
#' including but not limited to their date, description, and involved teams. 
#' Access `ns_seasons()` for `start_date` and `end_date` references. Note the 
#' date format differs from the NHL API; will soon be fixed to accept both.
#' 
#' @param start_date integer in YYYYMMDD (e.g., 20241004)
#' @param end_date integer in YYYYMMDD (e.g., 20250624)
#' @return data.frame with one row per transaction
#' @examples
#' ESPN_transactions_20242025 <- get_espn_transactions(
#'   start_date = 20241004, 
#'   end_date   = 20250624
#' )
#' @export

get_espn_transactions <- function(start_date = 20241004, end_date = 20250624) {
  tryCatch(
    expr = {
      page <- 1
      all_transactions <- list()
      repeat {
        transactions <- espn_api(
          path  = 'transactions',
          query = list(
            limit = 1000,
            page  = page,
            dates = sprintf('%s-%s', start_date, end_date)
          ),
          type = 'g'
        )
        df <- as.data.frame(transactions$transactions, stringsAsFactors = FALSE)
        all_transactions[[length(all_transactions) + 1]] <- df
        if (nrow(df) < 1000) break
        page <- page + 1
      }
      do.call(rbind, all_transactions)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the real-time ESPN injury reports
#' 
#' `get_espn_injuries()` retrieves real-time ESPN injury reports for all the 
#' teams.
#' 
#' @return nested data.frame with one row per team (outer) and player (inner)
#' @examples
#' ESPN_injuries_now <- get_espn_injuries()
#' @export

get_espn_injuries <- function() {
  espn_api(
    path  = 'injuries',
    query = list(limit = 1000),
    type  = 'g'
  )$injuries
}

#' Get the ESPN futures for a season
#' 
#' `get_espn_futures()` retrieves real-time ESPN futures of various types for a 
#' given `season`. Access `ns_seasons()` for `season` reference. Note the 
#' season format differs from the NHL API; will soon be fixed to accept both.
#' 
#' @param season integer in YYYY (e.g., 2026)
#' @return nested data.frame with one row per type (outer) and book (inner)
#' @examples
#' ESPN_futures_20252026 <- get_espn_futures(2026)
#' @export

get_espn_futures <- function(season = ns_season() %% 1e4) {
  tryCatch(
    expr = {
      espn_api(
        path  = sprintf('seasons/%s/futures', season),
        query = list(lang = 'en', region = 'us', limit = 1000),
        type  = 'c'
      )$items
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
