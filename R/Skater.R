#' Get the skater statistics leaders for a season, game type, and report type
#' 
#' `ns_skater_leaders()` retrieves information on each skater for a given set 
#' of `season`, `game_type`, and `category`, including but not limited to their 
#' ID, name, and statistics. Access `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type string of 'a'/'assists', 'g'/goals', 
#' 'shg'/'shorthanded goals', 'ppg'/'powerplay goals', 'p'/'points', 
#' 'pim'/penalty minutes'/'penalty infraction minutes', 'toi'/'time on ice', 
#' 'pm'/'plus minus', or 'f'/'faceoffs'
#' @return data.frame with one row per skater
#' @examples
#' toi_leaders_regular_20242025 <- ns_skater_leaders(
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'time on ice'
#' )
#' @export

ns_skater_leaders <- function(
    season      = 'current',
    game_type   = '',
    report_type = 'points'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        tolower(report_type),
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
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the skaters on milestone watch
#' 
#' `ns_skater_milestones()` retrieves information on each skater close to a 
#' milestone, including but not limited to their ID, name, and statistics.
#' 
#' @return data.frame with one row per skater
#' @examples
#' skater_milestones <- ns_skater_milestones()
#' @export

ns_skater_milestones <- function() {
  nhl_api(
    path = 'en/milestones/skaters',
    type = 's'
  )$data
}

#' Get the career statistics for all the skaters
#' 
#' `ns_skater_career_statistics()` retrieves information on ...
#' 
#' @return data.frame with one row per skater
#' @examples
#' skater_career_stats <- ns_skater_career_statistics()
#' @export

ns_skater_career_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-regular-plus-playoffs',
    type = 'r'
  )$data
}

#' @rdname ns_skater_career_statistics
#' @export
ns_skater_career_stats <- function() {
  ns_skater_career_statistics()
}

#' Get the career regular season statistics for all the skaters
#' 
#' `ns_skater_career_regular_statistics()` retrieves information on ...
#' 
#' @return data.frame with one row per skater
#' @examples
#' skater_career_regular_statistics <- ns_skater_career_regular_statistics()
#' @export

ns_skater_career_regular_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-regular-season',
    type = 'r'
  )$data
}

#' @rdname ns_skater_career_regular_statistics
#' @export
ns_skater_career_regular_stats <- function() {
  ns_skater_career_regular_statistics()
}

#' Get the career playoff statistics for all the skaters
#' 
#' `ns_skater_career_playoff_statistics()` retrieves information on ...
#' 
#' @return data.frame with one row per skater
#' @examples
#' skater_career_playoff_statistics <- ns_skater_career_playoff_statistics()
#' @export

ns_skater_career_playoff_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-playoffs',
    type = 'r'
  )$data
}

#' @rdname ns_skater_career_playoff_statistics
#' @export
ns_skater_career_playoff_stats <- function() {
  ns_skater_career_playoff_statistics()
}

#' Get the statistics for all the skaters by season, game type, and team
#' 
#' `ns_skater_season_statistics()` retrieves information on ...
#' 
#' @return data.frame with one row per skater per game type per season, 
#' separated by team when necessary
#' @examples
#' skater_season_stats <- ns_skater_season_statistics()
#' @export

ns_skater_season_statistics <- function() {
  nhl_api(
    path = 'player-stats',
    type = 'r'
  )$data
}

#' @rdname ns_skater_season_statistics
#' @export
ns_skater_season_stats <- function() {
  ns_skater_season_statistics()
}

#' Get the statistics for all the skaters by playoff series
#' 
#' `ns_skater_series_statistics()` retrieves information on ...
#' 
#' @return data.frame with one row per skater per series
#' @examples
#' skater_series_stats <- ns_skater_series_statistics()
#' @export

ns_skater_series_statistics <- function() {
  nhl_api(
    path = 'playoff-skater-series-stats',
    type = 'r'
  )$data
}

#' @rdname ns_skater_series_statistics
#' @export
ns_skater_series_stats <- function() {
  ns_skater_series_statistics()
}
