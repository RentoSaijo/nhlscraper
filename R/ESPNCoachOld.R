#' Access the ESPN coaches for a season
#' 
#' `get_espn_coaches()` is defunct. Use [coaches()] instead.
#' 
#' @export

get_espn_coaches <- function() {
  .Defunct(
    new     = 'coaches()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_coaches()` is defunct.',
      'Use `coaches()` instead.'
    )
  )
}

#' Access the ESPN statistics for a coach and (multiple) season(s)
#' 
#' `get_espn_coach()` is defunct. Use [coach_career_statistics()] instead.
#'
#' @export

get_espn_coach <- function() {
  .Defunct(
    new     = 'coach_career_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_coach()` is defunct.',
      'Use `coach_career_statistics()` instead.'
    )
  )
}

#' Access the career ESPN statistics for a coach
#'
#' `get_espn_coach_career()` is defunct. Use [coach_career_statistics()] instead.
#'
#' @export

get_espn_coach_career <- function() {
  .Defunct(
    new     = 'coach_career_statistics()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_coach_career()` is defunct.',
      'Use `coach_career_statistics()` instead.'
    )
  )
}
