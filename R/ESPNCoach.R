#' Get the ESPN coaches for a season
#' 
#' `get_espn_coaches()` retrieves the ESPN ID of each coach for a given 
#' `season`. Access `ns_seasons()` for `season` reference. Note the season 
#' format differs from the NHL API; will soon be fixed to accept both. 
#' Temporarily deprecated while we re-evaluate the practicality of ESPN API 
#' information. Use [ns_coaches()] instead.
#'  
#' @param season integer in YYYY (e.g., 2025)
#' @returns data.frame with one row per coach
#' @examples
#' ESPN_coaches_20242025 <- get_espn_coaches(2025)
#' @export

get_espn_coaches <- function(season = ns_season() %% 1e4) {
  .Deprecated(
    new     = 'ns_coaches()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_coaches()` is temporarily deprecated.',
      'Re-evaluating the practicality of ESPN API inforamtion.',
      'Use `ns_coaches()` instead.'
    )
  )
  tryCatch(
    expr = {
      coaches <- espn_api(
        path  = sprintf('seasons/%s/coaches', season),
        query = list(lang = 'en', region = 'us', limit = 1000),
        type  = 'c'
      )$items
      id  <- sub('.*coaches/([0-9]+)\\?lang.*', '\\1', coaches[[1]])
      data.frame(id = id, stringsAsFactors = FALSE)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the ESPN information on a coach for a season
#' 
#' `get_espn_coach()` is temporarily defunct while we re-evaluate the 
#' practicality of ESPN API information.
#'
#' @export

get_espn_coach <- function(coach = 5033, season = 'all') {
  .Defunct(
    msg = paste(
      '`get_espn_coach()` is temporarily defunct.',
      'Re-evaluating the practicality of ESPN API inforamtion.'
    )
  )
}

#' Get the ESPN career records of a coach for a game type
#' 
#' `get_espn_coach_career()` is temporarily defunct while we re-evaluate the 
#' practicality of ESPN API information.
#' 
#' @export

get_espn_coach_career <- function(coach = 5033, game_type = 0) {
  .Defunct(
    msg = paste(
      '`get_espn_coach_career()` is temporarily defunct.',
      'Re-evaluating the practicality of ESPN API inforamtion.'
    )
  )
}
