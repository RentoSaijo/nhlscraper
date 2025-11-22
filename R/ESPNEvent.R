#' Get the ESPN events for an interval of dates
#' 
#' `get_espn_events()` retrieves the ESPN ID for each event for an interval of 
#' dates bound by a given set of `start_date` and `end_date`. Access 
#' `ns_seasons()` for `start_date` and `end_date` references. Note the date 
#' format differs from the NHL API; will soon be fixed to accept both. 
#' Temporarily deprecated while we re-evaluate the practicality of ESPN API 
#' information. Use [ns_games()] instead.
#' 
#' @param start_date integer in YYYYMMDD (e.g., 20241004)
#' @param end_date integer in YYYYMMDD (e.g., 20250624)
#' @return data.frame with one row per ESPN event
#' @examples
#' ESPN_events_20242025 <- get_espn_events(
#'   start_date = 20241004, 
#'   end_date   = 20250624
#' )
#' @export

get_espn_events <- function(start_date = 20241004, end_date = 20250624) {
  .Deprecated(
    new     = 'ns_games()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_events()` is temporarily deprecated.',
      'Re-evaluating the practicality of ESPN API inforamtion.',
      'Use `ns_games()` instead.'
    )
  )
  tryCatch(
    expr = {
      page <- 1
      all_events <- list()
      repeat {
        events <- espn_api(
          path  = 'events',
          query = list(
            lang   = 'en',
            region = 'us',
            limit  = 1000,
            page   = page,
            dates  = sprintf('%s-%s', start_date, end_date)
          ),
          type = 'c'
        )
        df <- as.data.frame(events$items, stringsAsFactors = FALSE)
        all_events[[length(all_events) + 1]] <- df
        if (nrow(df) < 1000) break
        page <- page + 1
      }
      out <- do.call(rbind, all_events)
      id  <- sub('.*events/([0-9]+)\\?lang.*', '\\1', out[[1]])
      data.frame(id = id, stringsAsFactors = FALSE)
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get information on an ESPN event
#' 
#' `get_espn_event()` is temporarily defunct while we re-evaluate the 
#' practicality of ESPN API information.
#' 
#' @export

get_espn_event <- function(event = 401687600) {
  .Defunct(
    msg = paste(
      '`get_espn_event()` is temporarily defunct.',
      'Re-evaluating the practicality of ESPN API inforamtion.'
    )
  )
}

#' Get the play-by-play of an ESPN event
#' 
#' `get_espn_event_play_by_play()` retrieves ESPN-provided information on each 
#' play for a given `event`, including but not limited to their ID, type, time 
#' of occurrence, strength-state, participants, and X and Y coordinates. Access 
#' `get_espn_events()` for `event` reference.
#' 
#' @param event integer ESPN Event ID (e.g., 401687600)
#' @return data.frame with one row per play
#' @examples
#' NJD_BUF_2024_10_04_pbp <- get_espn_event_play_by_play(event = 401687600)
#' @export

get_espn_event_play_by_play <- function(event = 401687600) {
  tryCatch(
    expr = {
      espn_api(
        path  = sprintf('events/%s/competitions/%s/plays', event, event),
        query = list(lang = 'en', region = 'us', limit = 1000),
        type  = 'c'
      )$items
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' @rdname get_espn_event_play_by_play
#' @export
get_espn_event_pbp <- function(event = 401687600) {
  get_espn_event_play_by_play(event)
}


#' Get the three stars of an ESPN event
#' 
#' `get_espn_event_stars()` is defunct. Use [ns_gc_summary()] instead.
#' 
#' @export

get_espn_event_stars <- function(event = 401687600) {
  .Defunct(
    new     = 'ns_gc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event_stars()` is defunct.',
      'Use `ns_gc_summary()` instead.'
    )
  )
}

#' Get the officials of an event
#' 
#' `get_espn_event_officials()` is defunct. Use [ns_gc_summary()] instead.
#' 
#' @export

get_espn_event_officials <- function(event = 401687600) {
  .Defunct(
    new     = 'ns_gc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event_officials()` is defunct.',
      'Use `ns_gc_summary()` instead.'
    )
  )
}

#' Get the odds of an ESPN event
#' 
#' `get_espn_event_odds()` retrieves information on each provider for a given 
#' `event`, including but not limited to its name, favorite and underdog teams, 
#' and money-line and spread odds. Access `get_espn_events()` for `event` 
#' reference.
#'
#' @param event integer ESPN Event ID (e.g., 401687600)
#' @return data.frame with one row per provider
#' @examples
#' NJD_BUF_2024_10_04_odds <- get_espn_event_odds(event=401687600)
#' @export

get_espn_event_odds <- function(event = 401687600) {
  tryCatch(
    expr = {
      espn_api(
        path  = sprintf('events/%s/competitions/%s/odds', event, event),
        query = list(lang = 'en', region = 'us', limit = 1000),
        type  = 'c'
      )$items
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
