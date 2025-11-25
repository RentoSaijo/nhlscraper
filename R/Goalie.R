#' Get goalie statistics leaders by season, game-type, and category
#' 
#' `get_goalie_leaders()` retrieves information on each goalie for a given set of `season`, `game_type`, and `category`, including but not limited to their ID, name, and statistics. Access `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type string of 'w'/'wins', 's'/shutouts', 
#' 's%'/'sP'/'save %'/'save percentage', or 'gaa'/'goals against average'
#' @returns data.frame with one row per goalie
#' @examples
#' gaa_leaders_regular_20242025 <- goalie_leaders(
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'goals against average'
#' )
#' @export

goalie_leaders <- function(
    season      = 'current',
    game_type   = '',
    report_type = 'wins'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        tolower(report_type),
        w                       = 'wins',
        wins                    = 'wins',
        s                       = 'shutouts',
        shutouts                = 'shutouts',
        `s%`                    = 'savePctg',
        sp                      = 'savePctg',
        `save %`                = 'savePctg',
        `save percentage`       = 'savePctg',
        gaa                     = 'goalsAgainstAverage',
        `goals against average` = 'goalsAgainstAverage'
      )
      nhl_api(
        path  = sprintf('v1/goalie-stats-leaders/%s/%s', season, game_type),
        type  = 'w'
      )[[report_type]]
    },
    error = function(e) {
      message(e)
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the goalies on milestone watch
#' 
#' `get_goalie_milestones()` retrieves information on each goalie close to a 
#' milestone, including but not limited to their ID, name, and statistics.
#' 
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_milestones <- goalie_milestones()
#' @export

goalie_milestones <- function() {
  nhl_api(
    path = 'en/milestones/goalies',
    type = 's'
  )$data
}

#' Get the goalie statistics for all the games
#' 
#' `goalie_game_statistics()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie per game
#' @examples
#' goalie_game_stats <- goalie_game_statistics()
#' @export

goalie_game_statistics <- function() {
  nhl_api(
    path = 'goalie_career_stats_incl_playoffs',
    type = 'r'
  )$data
}

#' @rdname goalie_game_statistics
#' @export
goalie_game_stats <- function() {
  goalie_game_statistics()
}

#' Get the goalie statistics for all the seasons
#' 
#' `goalie_season_statistics()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie per season
#' @examples
#' goalie_season_stats <- goalie_season_statistics()
#' @export

goalie_season_statistics <- function() {
  nhl_api(
    path = 'goalie_season_stats_incl_playoffs',
    type = 'r'
  )$data
}

#' @rdname goalie_season_statistics
#' @export
goalie_season_stats <- function() {
  goalie_season_statistics()
}

#' Get the regular season goalie statistics for all the seasons
#' 
#' `goalie_season_regular_statistics()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie per season
#' @examples
#' goalie_season_regular_stats <- goalie_season_regular_statistics()
#' @export

goalie_season_regular_statistics <- function() {
  nhl_api(
    path = 'goalie-season-stats',
    type = 'r'
  )$data
}

#' @rdname goalie_season_regular_statistics
#' @export
goalie_season_regular_stats <- function() {
  goalie_season_regular_statistics()
}

#' Get the career statistics for all the goalies
#' 
#' `goalie_career_statistics()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_career_stats <- goalie_career_statistics()
#' @export

goalie_career_statistics <- function() {
  nhl_api(
    path = 'goalie_career_stats_incl_playoffs',
    type = 'r'
  )$data
}

#' @rdname goalie_career_statistics
#' @export
goalie_career_stats <- function() {
  goalie_career_statistics()
}

#' Get the career regular season statistics for all the goalies
#' 
#' `goalie_career_regular_statistics()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_career_regular_statistics <- goalie_career_regular_statistics()
#' @export

goalie_career_regular_statistics <- function() {
  nhl_api(
    path = 'goalie-career-stats',
    type = 'r'
  )$data
}

#' @rdname goalie_career_regular_statistics
#' @export
goalie_career_regular_stats <- function() {
  goalie_career_regular_statistics()
}

#' Get the career scoring totals for all the goalies
#' 
#' `goalie_career_scoring()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_career_scoring <- goalie_career_scoring()
#' @export

goalie_career_scoring <- function() {
  nhl_api(
    path = 'goalie-career-scoring',
    type = 'r'
  )$data
}

#' Get all the games in which at least one goalie got at least one point
#' 
#' `goalie_scoring_games()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_scoring_games <- goalie_scoring_games()
#' @export

goalie_scoring_games <- function() {
  nhl_api(
    path = 'goalie-career-scoring',
    type = 'r'
  )$data
}

#' Get the statistics for all the goalies by playoff series
#' 
#' `goalie_series_statistics()` retrieves information on ...
#' 
#' @returns data.frame with one row per goalie per series
#' @examples
#' goalie_series_stats <- goalie_series_statistics()
#' @export

goalie_series_statistics <- function() {
  nhl_api(
    path = 'playoff-goalie-series-stats',
    type = 'r'
  )$data
}

#' @rdname goalie_series_statistics
#' @export
goalie_series_stats <- function() {
  goalie_series_statistics()
}
