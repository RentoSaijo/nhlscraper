#' Get goalie statistics leaders by season, game-type, and category
#' 
#' `get_goalie_leaders()` retrieves information on each goalie for a given set of `season`, `game_type`, and `category`, including but not limited to their ID, name, and statistics. Access `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type string of 'w'/'wins', 's'/shutouts', 
#' 's%'/'sP'/'save %'/'save percentage', or 'gaa'/'goals against average'
#' @return data.frame with one row per goalie
#' @examples
#' gaa_leaders_regular_20242025 <- ns_goalie_leaders(
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'goals against average'
#' )
#' @export

ns_goalie_leaders <- function(
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the goalies on milestone watch
#' 
#' `get_goalie_milestones()` retrieves information on each goalie close to a 
#' milestone, including but not limited to their ID, name, and statistics.
#' 
#' @return data.frame with one row per goalie
#' @examples
#' goalie_milestones <- ns_goalie_milestones()
#' @export

ns_goalie_milestones <- function() {
  nhl_api(
    path = 'en/milestones/goalies',
    type = 's'
  )$data
}
