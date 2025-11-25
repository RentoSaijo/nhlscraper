#' Access the career statistics for all the goalies
#' 
#' `goalie_statistics()` scrapes the career statistics for all the 
#' goalies.
#' 
#' @returns data.frame with one row per player
#' @examples
#' goalie_stats <- goalie_statistics()
#' @export

goalie_statistics <- function() {
  stats    <- nhl_api(
    path = 'goalie_career_stats_incl_playoffs',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$playerId), ]
}

#' @rdname goalie_statistics
#' @export
goalie_stats <- function() {
  goalie_statistics()
}

#' Access the career regular season statistics for all the goalies
#' 
#' `goalie_regular_statistics()` scrapes the career regular season statistics 
#' for all the goalies.
#' 
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_career_regular_statistics <- goalie_regular_statistics()
#' @export

goalie_regular_statistics <- function() {
  stats    <- nhl_api(
    path = 'goalie-career-stats',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$playerId), ]
}

#' @rdname goalie_regular_statistics
#' @export
goalie_regular_stats <- function() {
  goalie_regular_statistics()
}


#' Access the statistics for all the goalies by season, game type, and team.
#' 
#' `goalie_season_statistics()` scrapes the statistics for all the goalies by 
#' season, game type, and team.
#' 
#' @returns data.frame with one row per player per season per game type, 
#' separated by team if applicable
#' @examples
#' goalie_season_stats <- goalie_season_statistics()
#' @export

goalie_season_statistics <- function() {
  stats    <- nhl_api(
    path = 'goalie-season-stats',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$playerId, stats$seasonId, stats$gameType), ]
}

#' @rdname goalie_season_statistics
#' @export
goalie_season_stats <- function() {
  goalie_season_statistics()
}

#' Access the statistics for all the goalies by game
#' 
#' `goalie_game_statistics()` scrapes the statistics for all the goalies by 
#' game.
#' 
#' @returns data.frame with one row per goalie per game
#' @examples
#' \donttest{goalie_game_stats <- goalie_game_statistics()}
#' @export

goalie_game_statistics <- function() {
  stats    <- nhl_api(
    path = 'goalie-game-stats',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$playerId, stats$gameId), ]
}

#' @rdname goalie_game_statistics
#' @export
goalie_game_stats <- function() {
  goalie_game_statistics()
}

#' Access the playoff statistics for all the goalies by series
#' 
#' `goalie_series_statistics()` scrapes the playoff statistics for all the 
#' goalies by series.
#' 
#' @returns data.frame with one row per player per series
#' @examples
#' goalie_series_stats <- goalie_series_statistics()
#' @export

goalie_series_statistics <- function() {
  stats    <- nhl_api(
    path = 'playoff-goalie-series-stats',
    type = 'r'
  )$data
  stats$id <- NULL
  stats
}

#' @rdname goalie_series_statistics
#' @export
goalie_series_stats <- function() {
  goalie_series_statistics()
}

#' Access the career scoring statistics for all the goalies
#' 
#' `goalie_scoring()` scrapes the career scoring statistics for all the 
#' goalies.
#' 
#' @returns data.frame with one row per player
#' @examples
#' goalie_scoring <- goalie_scoring()
#' @export

goalie_scoring <- function() {
  scoring    <- nhl_api(
    path = 'goalie-career-scoring',
    type = 'r'
  )$data
  scoring$id <- NULL
  scoring[order(scoring$playerId), ]
}

#' Access the scoring statistics for all the goalies by game
#' 
#' `goalie_game_scoring()` scrapes the scoring statistics for all the goalies 
#' by game.
#' 
#' @returns data.frame with one row per player per game
#' @examples
#' goalie_game_scoring <- goalie_game_scoring()
#' @export

goalie_game_scoring <- function() {
  scoring    <- nhl_api(
    path = 'goalie-game-scoring',
    type = 'r'
  )$data
  scoring$id <- NULL
  scoring[order(scoring$playerId, scoring$gameId), ]
}

#' Access the goalie statistics leaders for a season, game type, and report type
#' 
#' `goalie_leaders()` scrapes the goalie statistics leaderboard for a given 
#' set of `season`, `game_type`, and `report_type`.
#' 
#' @inheritParams roster_statistics
#' @param report_type character of 'w'/'wins', 's'/shutouts', 
#' 's%'/'sP'/'save %'/'save percentage', or 'gaa'/'goals against average'
#' @returns data.frame with one row per player
#' @examples
#' GAA_leaders_regular_20242025 <- goalie_leaders(
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'GAA'
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

#' Access the goalies on milestone watch
#' 
#' `goalie_milestones()` scrapes information on the goalies on milestone 
#' watch.
#' 
#' @returns data.frame with one row per player
#' @examples
#' goalie_milestones <- goalie_milestones()
#' @export

goalie_milestones <- function() {
  nhl_api(
    path = 'en/milestones/goalies',
    type = 's'
  )$data
}
