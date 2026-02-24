#' Access all the playoff series by game
#'
#' `series()` retrieves all the playoff series by game as a `data.frame` where each row represents game per series and includes detail on game timeline state, period/clock progression, and matchup flow, date/season filtering windows and chronological context, and playoff-series progression, round status, and series leverage.
#'
#' @returns data.frame with one row per game per series
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_series <- series()}
#' @export

series <- function() {
  tryCatch({
    series    <- nhl_api(
      path = 'playoff-series',
      type = 'r'
    )$data
    series$id <- NULL
    series[order(series$seasonId, series$playoffSeriesLetter, series$gameId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the playoff statistics by season
#'
#' `playoff_season_statistics()` retrieves the playoff statistics by season as a `data.frame` where each row represents season and includes detail on date/season filtering windows and chronological context.
#'
#' @returns data.frame with one row per season
#' @examples
#' playoff_season_stats <- playoff_season_statistics()
#' @export

playoff_season_statistics <- function() {
  tryCatch({
    totals    <- nhl_api(
      path = 'league-playoff-year-totals',
      type = 'r'
    )$data
    totals$id <- NULL
    totals[order(totals$seasonId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname playoff_season_statistics
#' @export

playoff_season_stats <- function() {
  playoff_season_statistics()
}

#' Access the playoff bracket for a season
#'
#' `bracket()` retrieves the playoff bracket for a season as a `data.frame` where each row represents series and includes detail on team identity, affiliation, and matchup-side context.
#'
#' @inheritParams roster
#'
#' @returns data.frame with one row per series
#' @examples
#' bracket_20242025 <- bracket(season = 20242025)
#' @export

bracket <- function(season = season_now()){
  tryCatch(
    expr = {
      series <- data.frame(nhl_api(
        path = sprintf(
          'v1/playoff-bracket/%s', 
          suppressWarnings(as.integer(season)) %% 1e4
        ),
        type = 'w'
      )$series)
      names(series) <- normalize_locale_names(names(series))
      names(series) <- normalize_team_abbrev_cols(names(series))
      series
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the playoff schedule for a season and series
#'
#' `series_schedule()` retrieves the playoff schedule for a season and series as a `data.frame` where each row represents game and includes detail on game timeline state, period/clock progression, and matchup flow, date/season filtering windows and chronological context, and team identity, affiliation, and matchup-side context.
#'
#' @inheritParams roster
#' @param series one-letter code (e.g., 'O'); see [series()] and/or 
#' [bracket()] for reference
#'
#' @returns data.frame with one row per game
#' @examples
#' SCF_schedule_20212022 <- series_schedule(
#'   season = 20212022, 
#'   series = 'O'
#' )
#' @export

series_schedule <- function(season = season_now() - 10001, series = 'a') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf(
          'v1/schedule/playoff-series/%s/%s', 
          season, 
          tolower(series)
        ),
        type = 'w'
      )$games
      names(games)[names(games) == 'id']       <- 'gameId'
      names(games)[names(games) == 'season']   <- 'seasonId'
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      names(games) <- normalize_locale_names(names(games))
      names(games) <- normalize_team_abbrev_cols(names(games))
      games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
