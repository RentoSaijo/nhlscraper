#' Access the ESPN games for a season
#'
#' `espn_games()` retrieves the ESPN games for a season as a `data.frame` where each row represents ESPN and includes detail on game timing, matchup state, scoring flow, and situational event detail.
#'
#' @inheritParams roster
#'
#' @returns data.frame with one row per ESPN game
#' @examples
#' ESPN_games_20242025 <- espn_games(season = 20242025)
#' @export

espn_games <- function(season = season_now()) {
  tryCatch(
    expr = {
      seasons_tbl <- seasons()
      season_row  <- seasons_tbl[seasons_tbl$id == season, ]
      start_src   <- season_row$preseasonStartdate
      if (is.null(start_src) || is.na(start_src)) {
        start_src <- season_row$startDate
      }
      end_src     <- season_row$endDate
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
      start_str  <- format(start_date, '%Y%m%d')
      end_str    <- format(end_date, '%Y%m%d')
      page       <- 1
      all_events <- list()
      repeat {
        events <- espn_api(
          path  = 'events',
          query = list(
            lang   = 'en',
            region = 'us',
            limit  = 1000,
            page   = page,
            dates  = sprintf('%s-%s', start_str, end_str)
          ),
          type  = 'c'
        )
        df <- as.data.frame(events$items, stringsAsFactors = FALSE)
        all_events[[length(all_events) + 1]] <- df
        if (nrow(df) < 1000) {
          break
        }
        page <- page + 1
      }
      out <- do.call(rbind, all_events)
      id  <- sub('.*events/([0-9]+)\\?lang.*', '\\1', out[[1]])
      data.frame(id = id, stringsAsFactors = FALSE)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the ESPN summary for a game
#'
#' `espn_game_summary()` retrieves the ESPN summary for a game as a nested `list` that separates summary and detail blocks for date/season filtering windows and chronological context, venue/location geography and regional metadata, and playoff-series progression, round status, and series leverage.
#'
#' @param game integer ID (e.g., 401777460); see [espn_games()] for 
#' reference
#'
#' @returns list with various items
#' @examples
#' ESPN_summary_SCF_20242025 <- espn_game_summary(game = 401777460)
#' @export

espn_game_summary <- function(game = 401777460) {
  tryCatch(
    expr = {
      game  <- espn_api(
        path  = sprintf('events/%s/competitions/%s', game, game),
        type  = 'c'
      )
      keeps <- setdiff(names(game), c(
        '$ref',
        'guid',
        'uid',
        'previewAvailable',
        'recapAvailable',
        'boxscoreAvailable',
        'lineupAvailable',
        'gamecastAvailable',
        'conversationAvailable',
        'commentaryAvailable',
        'summaryAvailable',
        'liveAvailable',
        'ticketsAvailable',
        'shotChartAvailable',
        'possessionArrowAvailable',
        'onWatchESPN',
        'recent',
        'bracketAvailable',
        'wallclockAvailable',
        'highlightsAvailable',
        'gameSource',
        'boxscoreSource',
        'playByPlaySource',
        'linescoreSource',
        'statsSource',
        'situation',
        'status',
        'odds',
        'broadcasts',
        'officials',
        'details',
        'links',
        ''
      ))
      game[keeps]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the ESPN play-by-play for a game
#'
#' `espn_play_by_play()` retrieves the ESPN play-by-play for a game as a `data.frame` where each row represents event and includes detail on game timeline state, period/clock progression, and matchup flow, team identity, affiliation, and matchup-side context, and situational splits across home/road, strength state, and overtime/shootout states.
#'
#' @inheritParams espn_game_summary
#'
#' @returns data.frame with one row per event (play)
#' @examples
#' ESPN_pbp_SCF_20242025 <- espn_play_by_play(game = 401777460)
#' @export

espn_play_by_play <- function(game = 401777460) {
  tryCatch(
    expr = {
      espn_api(
        path  = sprintf('events/%s/competitions/%s/plays', game, game),
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

#' @rdname espn_play_by_play
#' @export

espn_pbp <- function(game = 401777460) {
  espn_play_by_play(game)
}

#' Access the ESPN odds for a game
#'
#' `espn_game_odds()` retrieves the ESPN odds for a game as a `data.frame` where each row represents provider and includes detail on team identity, affiliation, and matchup-side context plus betting market snapshots with side/total prices and provider variation.
#'
#' @inheritParams espn_game_summary
#'
#' @returns data.frame with one row per provider
#' @examples
#' ESPN_odds_SCF_20242025 <- espn_game_odds(game = 401777460)
#' @export

espn_game_odds <- function(game = 401777460) {
  tryCatch(
    expr = {
      espn_api(
        path  = sprintf('events/%s/competitions/%s/odds', game, game),
        type  = 'c'
      )$items
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
