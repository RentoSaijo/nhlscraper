#' Access the ESPN transactions for a season
#' 
#' `espn_transactions()` scrapes the ESPN transactions for a given `season`.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025); the summer of the latter 
#' year is included
#' 
#' @returns data.frame with one row per transaction
#' @examples
#' ESPN_transactions_20242025 <- espn_transactions(season = 20242025)
#' @export

espn_transactions <- function(season = season_now()) {
  tryCatch(
    expr = {
      seasons_tbl <- seasons()
      idx         <- which(seasons_tbl$id == season)
      this_season <- seasons_tbl[idx, , drop = FALSE]
      start_src   <- this_season$preseasonStartdate
      if (is.null(start_src) || is.na(start_src)) {
        start_src <- this_season$startDate
      }
      if (idx < nrow(seasons_tbl)) {
        next_season  <- seasons_tbl[idx + 1, , drop = FALSE]
        next_start   <- next_season$preseasonStartdate
        if (is.null(next_start) || is.na(next_start)) {
          next_start <- next_season$startDate
        }
        if (!inherits(next_start, 'Date')) {
          next_start <- as.Date(as.character(next_start))
        }
        end_src <- next_start - 1
      } else {
        end_src <- this_season$endDate
      }
      if (!inherits(start_src, 'Date')) {
        start_date <- as.Date(as.character(start_src))
      } else {
        start_date <- start_src
      }
      if (!inherits(end_src, 'Date')) {
        end_date <- as.Date(as.character(end_src))
      } else {
        end_date <- end_src
      }
      start_str <- format(start_date, '%Y%m%d')
      end_str   <- format(end_date, '%Y%m%d')
      page             <- 1
      all_transactions <- list()
      repeat {
        transactions <- espn_api(
          path  = 'transactions',
          query = list(
            limit = 1000,
            page  = page,
            dates = sprintf('%s-%s', start_str, end_str)
          ),
          type = 'g'
        )
        df <- as.data.frame(transactions$transactions, stringsAsFactors = FALSE)
        all_transactions[[length(all_transactions) + 1]] <- df
        if (nrow(df) < 1000) {
          break
        }
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

#' Access the ESPN futures for a season
#' 
#' `espn_futures()` scrapes the ESPN futures for a given `season`.
#' 
#' @inheritParams roster
#' @returns nested data.frame with one row per type (outer) and book (inner)
#' @examples
#' ESPN_futures_20252026 <- espn_futures(20252026)
#' @export

espn_futures <- function(season = season_now()) {
  tryCatch(
    expr = {
      season <- season %% 1e4
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

#' Access the real-time ESPN injury reports
#' 
#' `espn_injuries()` scrapes the real-time ESPN injury reports for all the 
#' teams.
#' 
#' @returns nested data.frame with one row per team (outer) and player (inner)
#' @examples
#' ESPN_injuries_now <- espn_injuries()
#' @export

espn_injuries <- function() {
  tryCatch({
    teams <- espn_api(
      path  = 'injuries',
      query = list(limit = 1000),
      type  = 'g'
    )$injuries
    teams[order(as.integer(teams$id)), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
