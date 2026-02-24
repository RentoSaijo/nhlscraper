#' Access the ESPN transactions for a season
#'
#' `espn_transactions()` retrieves the ESPN transactions for a season as a `data.frame` where each row represents transaction and includes detail on availability and transaction-status tracking detail.
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
      season <- as.integer(season[[1]])
      if (is.na(season)) {
        stop('Invalid season.')
      }
      seasons_tbl <- seasons()
      idx         <- which(seasons_tbl$seasonId == season)
      if (!length(idx)) {
        stop('No season metadata found for season: ', season)
      }
      idx         <- idx[[1]]
      this_season <- seasons_tbl[idx, , drop = FALSE]
      start_src   <- this_season$preseasonStartdate[[1]]
      if (is.null(start_src) || is.na(start_src)) {
        start_src <- this_season$startDate[[1]]
      }
      if (idx < nrow(seasons_tbl)) {
        next_season  <- seasons_tbl[idx + 1, , drop = FALSE]
        next_start   <- next_season$preseasonStartdate[[1]]
        if (is.null(next_start) || is.na(next_start)) {
          next_start <- next_season$startDate[[1]]
        }
        if (!inherits(next_start, 'Date')) {
          next_start <- as.Date(as.character(next_start))
        }
        end_src <- next_start - 1
      } else {
        end_src <- this_season$endDate[[1]]
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
      transactions <- do.call(rbind, all_transactions)
      if (!is.null(transactions) && ncol(transactions)) {
        nms <- names(transactions)
        nms <- normalize_locale_names(nms)
        nms <- normalize_team_abbrev_cols(nms)
        nms <- ifelse(nms == 'teamId', 'espnTeamId', nms)
        names(transactions) <- nms
      }
      transactions
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the ESPN futures for a season
#'
#' `espn_futures()` retrieves the ESPN futures for a season as a `data.frame` where each row represents type and includes detail on betting market snapshots with side/total prices and provider variation.
#'
#' @inheritParams roster
#'
#' @returns nested data.frame with one row per type (outer) and book (inner)
#' @examples
#' ESPN_futures_20252026 <- espn_futures(20252026)
#' @export

espn_futures <- function(season = season_now()) {
  tryCatch(
    expr = {
      season <- as.integer(season[[1]])
      if (is.na(season) || !season %in% seasons()$seasonId) {
        stop('Invalid season.')
      }
      season <- season %% 1e4
      futures <- espn_api(
        path  = sprintf('seasons/%s/futures', season),
        query = list(lang = 'en', region = 'us', limit = 1000),
        type  = 'c'
      )$items
      if (!is.data.frame(futures)) {
        futures <- as.data.frame(futures, stringsAsFactors = FALSE)
      }
      names(futures)[names(futures) == 'id']          <- 'espnFutureId'
      names(futures)[names(futures) == 'name']        <- 'futureName'
      names(futures)[names(futures) == 'displayName'] <- 'futureDisplayName'
      futures
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the real-time ESPN injury reports
#'
#' `espn_injuries()` retrieves the real-time ESPN injury reports as a `data.frame` where each row represents team and includes detail on availability status tracking for injuries or transactions.
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
    names(teams)[names(teams) == 'id']          <- 'espnTeamId'
    names(teams)[names(teams) == 'displayName'] <- 'teamDisplayName'
    teams[order(as.integer(teams$espnTeamId)), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
