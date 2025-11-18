#' Get skater statistics
#' 
#' `get_skater_statistics()` retrieves information on each skater or game for a given set of `season`, `teams`, `game_types`, and `report`. `dates` must be given when paired with `is_game` as the default range will return incomplete data (too wide).  Access `get_configuration()` for what information each combination of `report`, `is_aggregate` and `is_game` can provide. Access `get_seasons()` for `season` and `dates` and `get_teams()` for `teams` references. Will soon be reworked for easier access.
#' 
#' @param season integer in YYYYYYYY
#' @param teams vector of integers Team ID(s)
#' @param game_types vector of integers where 1=pre-season, 2=regular, and 
#'                   3=playoffs
#' @param dates vector of strings in 'YYYY-MM-DD'
#' @param report string
#' @param is_aggregate boolean
#' @param is_game boolean
#' @return tibble with one row per skater or game
#' @examples
#' regular_skater_shootout_20242025 <- get_skater_statistics(
#'   season=20242025,
#'   game_types=c(2),
#'   report='shootout'
#' )
#' @export

get_skater_statistics <- function(
    season=get_season_now()$seasonId,
    teams=1:100,
    game_types=1:3,
    dates=c('2025-01-01'),
    report='summary',
    is_aggregate=FALSE,
    is_game=FALSE
) {
  if (is_game) {
    for (date in dates) {
      if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
        stop('date in `dates` must be in \'YYYY-MM-DD\' format', call.=FALSE)
      }
    }
    out <- nhl_api(
      path=sprintf('skater/%s', report),
      query=list(
        limit=-1,
        isGame=TRUE,
        isAggregate=is_aggregate,
        cayenneExp=sprintf(
          'seasonId=%s and gameDate in (%s) and teamId in (%s) and gameTypeId in (%s)',
          season,
          paste0('\'', dates, '\'', collapse=','),
          paste(teams, collapse=','),
          paste(game_types, collapse=',')
        )
      ),
      type=2
    )
  }
  else {
    out <- nhl_api(
      path=sprintf('skater/%s', report),
      query=list(
        limit=-1,
        isAggregate=is_aggregate,
        cayenneExp=sprintf(
          'seasonId=%s and teamId in (%s) and gameTypeId in (%s)',
          season,
          paste(teams, collapse=','),
          paste(game_types, collapse=',')
        )
      ),
      type=2
    )
  }
  return(tibble::as_tibble(out$data))
}

#' Get skater statistics leaders by season, game-type, and category
#' 
#' `get_skater_leaders()` retrieves information on each skater for a given set of `season`, `game_type`, and `category`, including but not limited to their ID, name, and statistics. Access `get_seasons()` for `season` reference.
#' 
#' @param season integer in YYYYYYYY
#' @param game_type integer where 2=regular and 3=playoffs
#' @param category string of 'assists', 'goals', 'goalsSh', 'goalsPp', 'points',
#'                 'penaltyMins', 'toi', 'plusMinus', or 'faceoffLeaders'
#' @return tibble with one row per skater
#' @examples
#' playoff_toi_leaders_20242025 <- get_skater_leaders(
#'   season=20242025,
#'   game_type=3,
#'   category='toi'
#' )
#' @export

get_skater_leaders <- function(
    season=get_season_now()$seasonId,
    game_type=2,
    category='points'
) {
  out <- nhl_api(
    path=sprintf('skater-stats-leaders/%s/%s', season, game_type),
    query=list(categories=category, limit=-1),
    type=1
  )
  return(tibble::as_tibble(out[[category]]))
}

#' Get skater milestones
#' 
#' `get_skater_milestones()` retrieves information on each skater close to a milestone, including but not limited to their ID, name, and statistics.
#' 
#' @return tibble with one row per skater
#' @examples
#' skater_milestones <- get_skater_milestones()
#' @export

get_skater_milestones <- function() {
  out <- nhl_api(
    path='milestones/skaters',
    type=2
  )
  return(tibble::as_tibble(out$data))
}
