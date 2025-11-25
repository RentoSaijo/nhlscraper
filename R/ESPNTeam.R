#' Get the ESPN teams for a season
#' 
#' `get_espn_teams()` retrieves the ESPN ID of each team for a given `season`. 
#' Access `seasons()` for `season` reference. Note the season format differs 
#' from the NHL API; will soon be fixed to accept both. Temporarily deprecated 
#' while we re-evaluate the practicality of ESPN API information. Use 
#' [teams()] instead.
#'  
#' @param season integer in YYYY (e.g., 2025)
#' @returns data.frame with one row per team
#' @examples
#' ESPN_teams_20242025 <- get_espn_teams(2025)
#' @export

get_espn_teams <- function(season = season() %% 1e4) {
  .Deprecated(
    new     = 'teams()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_coaches()` is temporarily deprecated.',
      'Re-evaluating the practicality of ESPN API inforamtion.',
      'Use `teams()` instead.'
    )
  )
  tryCatch(
    expr = {
      teams <- espn_api(
        path  = sprintf('seasons/%s/teams', season),
        query = list(lang = 'en', region = 'us', limit = 1000),
        type  = 'c'
      )$items
      id  <- sub('.*teams/([0-9]+)\\?lang.*', '\\1', teams[[1]])
      data.frame(id = id, stringsAsFactors = FALSE)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the ESPN information on a team for a season
#' 
#' `get_espn_team()` is temporarily defunct while we re-evaluate the 
#' practicality of ESPN API information.
#'
#' @export

get_espn_team <- function(team = 1, season = season() %% 1e4) {
  .Defunct(
    msg = paste(
      '`get_espn_team()` is temporarily defunct.',
      'Re-evaluating the practicality of ESPN API inforamtion.'
    )
  )
}
