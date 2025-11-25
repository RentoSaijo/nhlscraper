#' Access the career statistics for all the skaters
#' 
#' `skater_statistics()` scrapes the career statistics for all the skaters.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_stats <- skater_statistics()
#' @export

skater_statistics <- function() {
  stats    <- nhl_api(
    path = 'skater-career-scoring-regular-plus-playoffs',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$playerId), ]
}

#' @rdname skater_statistics
#' @export
skater_stats <- function() {
  skater_statistics()
}

#' Access the career regular season statistics for all the skaters
#' 
#' `skater_regular_statistics()` scrapes the career regular season statistics 
#' for all the skaters.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_regular_stats <- skater_regular_statistics()
#' @export

skater_regular_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-regular-season',
    type = 'r'
  )$data
}

#' @rdname skater_regular_statistics
#' @export
skater_regular_stats <- function() {
  skater_regular_statistics()
}

#' Access the career playoff statistics for all the skaters
#' 
#' `skater_playoff_statistics()` scrapes the career playoff statistics for all 
#' the skaters.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_playoff_stats <- skater_playoff_statistics()
#' @export

skater_playoff_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-playoffs',
    type = 'r'
  )$data
}

#' @rdname skater_playoff_statistics
#' @export
skater_playoff_stats <- function() {
  skater_playoff_statistics()
}

#' Access the statistics for all the skaters by season, game type, and team
#' 
#' `skater_season_statistics()` scrapes the statistics for all the skaters by 
#' season, game type, and team.
#' 
#' @returns data.frame with one row per player per season per game type, 
#' separated by team if applicable
#' @examples
#' # This may take >5s, so skip.
#' \donttest{skater_season_stats <- skater_season_statistics()}
#' @export

skater_season_statistics <- function() {
  stats                    <- nhl_api(
    path = 'player-stats',
    type = 'r'
  )$data
  stats$`id.db:SEQUENCENO` <- NULL
  stats[order(stats$`id.db:PLAYERID`, stats$`id.db:SEASON`), ]
}

#' @rdname skater_season_statistics
#' @export
skater_season_stats <- function() {
  skater_season_statistics()
}

#' Access the playoff statistics for all the skaters by series
#' 
#' `skater_series_statistics()` scrapes the playoff statistics for all the 
#' skaters by series.
#' 
#' @returns data.frame with one row per player per series
#' @examples
#' # This may take >5s, so skip.
#' \donttest{skater_series_stats <- skater_series_statistics()}
#' @export

skater_series_statistics <- function() {
  stats    <- nhl_api(
    path = 'playoff-skater-series-stats',
    type = 'r'
  )$data
  stats$id <- NULL
  stats
}

#' @rdname skater_series_statistics
#' @export
skater_series_stats <- function() {
  skater_series_statistics()
}

#' Access the skater statistics leaders for a season, game type, and category
#' 
#' `skater_leaders()` scrapes the skater statistics leaders for a given set of 
#' `season`, `game_type`, and `category`.
#' 
#' @inheritParams roster_statistics
#' @param category string of 'a'/'assists', 'g'/goals', 
#' 'shg'/'shorthanded goals', 'ppg'/'powerplay goals', 'p'/'points', 
#' 'pim'/penalty minutes'/'penalty infraction minutes', 'toi'/'time on ice', 
#' 'pm'/'plus minus', or 'f'/'faceoffs'
#' @returns data.frame with one row per player
#' @examples
#' TOI_leaders_regular_20242025 <- skater_leaders(
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'TOI'
#' )
#' @export

skater_leaders <- function(
  season    = 'current',
  game_type = '',
  category  = 'points'
) {
  tryCatch(
    expr = {
      category <- switch(
        tolower(category),
        a                            = 'assists',
        assists                      = 'assists',
        g                            = 'goals',
        goals                        = 'goals',
        shg                          = 'goalsSh',
        `shothanded goals`           = 'goalsSh',
        ppg                          = 'goalsPp',
        `powerplay goals`            = 'goalsPp',
        p                            = 'points',
        points                       = 'points',
        pim                          = 'penaltyMins',
        `penalty minutes`            = 'penaltyMins',
        `penalty infraction minutes` = 'penaltyMins',
        toi                          = 'toi',
        `time on ice`                = 'toi',
        pm                           = 'plusMinus',
        `plus minus`                 = 'plusMinus',
        f                            = 'faceoffLeaders',
        faceoffs                     = 'faceoffLeaders'
      )
      nhl_api(
        path  = sprintf('v1/skater-stats-leaders/%s/%s', season, game_type),
        type  = 'w'
      )[[category]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the skaters on milestone watch
#' 
#' `skater_milestones()` scrapes the skaters on milestone watch.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_milestones <- skater_milestones()
#' @export

skater_milestones <- function() {
  nhl_api(
    path = 'en/milestones/skaters',
    type = 's'
  )$data
}
