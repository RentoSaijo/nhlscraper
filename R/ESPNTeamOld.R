#' Access all the ESPN teams for a season
#' 
#' `get_espn_teams()` is defunct. Use [espn_teams()] instead.
#' 
#' @export

get_espn_teams <- function() {
  .Defunct(
    new     = 'espn_teams()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_teams()` is defunct.',
      'Use `espn_teams()` instead.'
    )
  )
}

#' Access the ESPN summary for a team and season
#' 
#' `get_espn_team()` is defunct. Use [espn_team_summary()] instead.
#' 
#' @export

get_espn_team <- function() {
  .Defunct(
    new     = 'espn_team_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_team()` is defunct.',
      'Use `espn_team_summary()` instead.'
    )
  )
}
