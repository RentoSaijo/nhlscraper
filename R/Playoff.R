#' Access all the playoff series by game
#' 
#' `ns_series()` scrapes information on all the playoff series by game.
#'
#' @returns data.frame with one row per game per series
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_series <- ns_series()}
#' @export

ns_series <- function() {
  series    <- nhl_api(
    path = 'playoff-series',
    type = 'r'
  )$data
  series$id <- NULL
  series    <- series[order(series$gameId), ]
  series    <- series[order(series$playoffSeriesLetter), ]
  series[order(series$seasonId), ]
}

#' Access the playoff statistics by season
#' 
#' `ns_playoff_season_statistics()` scrapes the playoff statistics by season.
#' 
#' @returns data.frame with one row per season
#' @examples
#' playoff_season_stats <- ns_playoff_season_statistics()
#' @export

ns_playoff_season_statistics <- function() {
  totals    <- nhl_api(
    path = 'league-playoff-year-totals',
    type = 'r'
  )$data
  totals$id <- NULL
  totals[order(totals$seasonId), ]
}

#' @rdname ns_playoff_season_statistics
#' @export
ns_playoff_season_stats <- function() {
  ns_playoff_season_statistics()
}

#' Access the playoff bracket for a season
#' 
#' `ns_bracket()` scrapes the playoff bracket for a given `season`.
#' 
#' @inheritParams ns_roster
#' @returns data.frame with one row per series
#' @examples
#' bracket_20242025 <- ns_bracket(season = 20242025)
#' @export

ns_bracket <- function(season = ns_season()){
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
#' `ns_series_schedule()` scrapes the playoff schedule for a given set of 
#' `season` and `series`.
#' 
#' @inheritParams ns_roster
#' @param series one-letter code (e.g., 'O'); see [ns_series()] and/or 
#' [ns_bracket()] for reference
#' @returns data.frame with one row per game
#' @examples
#' SCF_schedule_20212022 <- ns_series_schedule(
#'   season = 20212022, 
#'   series = 'O'
#' )
#' @export

ns_series_schedule <- function(season = ns_season(), series = 'a') {
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
