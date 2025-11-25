#' Access all the playoff series by game
#' 
#' `series()` scrapes all the playoff series by game.
#'
#' @returns data.frame with one row per game per series
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_series <- series()}
#' @export

series <- function() {
  series    <- nhl_api(
    path = 'playoff-series',
    type = 'r'
  )$data
  series$id <- NULL
  series[order(series$seasonId, series$playoffSeriesLetter, series$gameId), ]
}

#' Access the playoff statistics by season
#' 
#' `playoff_season_statistics()` scrapes the playoff statistics by season.
#' 
#' @returns data.frame with one row per season
#' @examples
#' playoff_season_stats <- playoff_season_statistics()
#' @export

playoff_season_statistics <- function() {
  totals    <- nhl_api(
    path = 'league-playoff-year-totals',
    type = 'r'
  )$data
  totals$id <- NULL
  totals[order(totals$seasonId), ]
}

#' @rdname playoff_season_statistics
#' @export
playoff_season_stats <- function() {
  playoff_season_statistics()
}

#' Access the playoff bracket for a season
#' 
#' `bracket()` scrapes the playoff bracket for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per series
#' @examples
#' bracket_20242025 <- bracket(season = 20242025)
#' @export

bracket <- function(season = season()){
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/playoff-bracket/%s', as.integer(season) %% 1e4),
        type = 'w'
      )$series
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the playoff schedule for a season and series
#' 
#' `series_schedule()` scrapes the playoff schedule for a given set of 
#' `season` and `series`.
#' 
#' @inheritParams roster
#' @param series one-letter code (e.g., 'O'); see [series()] and/or 
#' [bracket()] for reference
#' @returns data.frame with one row per game
#' @examples
#' SCF_schedule_20212022 <- series_schedule(
#'   season = 20212022, 
#'   series = 'O'
#' )
#' @export

series_schedule <- function(season = season(), series = 'a') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/schedule/playoff-series/%s/%s', 
          season, 
          tolower(series)
        ),
        type = 'w'
      )$games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
