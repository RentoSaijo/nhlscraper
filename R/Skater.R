#' Get all skaters' biographies by range of seasons
#' 
#' @importFrom magrittr %>%
#' @param start_season integer Season to start search in YYYYYYYY
#' @param end_season integer Season to end search in YYYYYYYY
#' @return tibble with one row per skater
#' @examples
#' skaters_2000s <- get_skaters(start_season=20002001, end_season=20242025)
#' @export

get_skaters <- function(
    start_season=19171918,
    end_season=get_season_now()$seasonId
  ) {
  start_year <- start_season %/% 10000
  end_year <- end_season %% 10000
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf('%04d', (start_year:(end_year-1))+1)
  )
  season_chunks <- split(seasons, ceiling(seq_along(seasons)/25))
  all_pages <- list()
  for (chunk in season_chunks) {
    min_season <- min(as.integer(chunk))
    max_season <- max(as.integer(chunk))
    out <- nhl_api(
      path='skater/bios',
      query=list(
        isAggregate=TRUE,
        limit=-1,
        start=0,
        sort='playerId',
        cayenneExp=sprintf(
          'seasonId>=%d and seasonId<=%d',
          min_season,
          max_season
        )
      ),
      type=2
    )
    df <- tibble::as_tibble(out$data)
    if (nrow(df)>0) {
      df$max_season_chunk <- max_season
      all_pages[[length(all_pages)+1]] <- df
    }
  }
  combined <- dplyr::bind_rows(all_pages)
  if (nrow(combined)==0) {
    return(tibble::tibble())
  }
  stats_sum <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::summarise(
      assists=sum(assists, na.rm=TRUE),
      gamesPlayed=sum(gamesPlayed, na.rm=TRUE),
      goals=sum(goals, na.rm=TRUE),
      points=sum(points, na.rm=TRUE),
      .groups='drop'
    )
  latest <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::slice_max(order_by=max_season_chunk, n=1 , with_ties=FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::select(-assists, -gamesPlayed, -goals, -points, -max_season_chunk)
  final <- latest %>%
    dplyr::left_join(stats_sum, by='playerId')
  return(final)
}

#' Get skater statistics leaders by season, game-type, and category
#' 
#' @param season integer Season in YYYYYYYY
#' @param game_type integer GameType where 2=regular and 3=playoffs
#' @param category string e.g. assists, goals, goalsSh, goalsPp, points,
#'                 penaltyMins, toi, plusMinus, faceoffLeaders
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
#' @return tibble with one row per skater
#' @examples
#' skater_milestones <- get_skater_milestones()
#' @export

get_skater_milestones <- function() {
  out <- nhl_api(
    path='milestones/skaters',
    query=list(),
    type=2
  )
  return(tibble::as_tibble(out$data))
}

#' Get skater statistics by season
#' 
#' @param season integer Season in YYYYYYYY
#' @param report string Report (check `get_configuration()` for possible inputs)
#' @param teams vector of integers Team ID(s)
#' @param is_aggregate boolean isAggregate where TRUE=regular and playoffs
#'                     combined (or multiple seasons) from multiple teams, if
#'                     applicable
#' @param is_game boolean isGame where TRUE=rows by games and FALSE=rows by
#'                skaters
#' @param dates vector of strings Date(s) in 'YYYY-MM-DD' (only if paired with
#'              `is_game`)
#' @param game_types vector of integers Game-type(s) where 1=pre-season,
#'                   2=regular, and 3=playoffs
#' @return tibble with one row per skater or game
#' @examples
#' regular_skater_shootout_20242025 <- get_skater_statistics(
#'   season=20242025,
#'   report='shootout',
#'   game_types=c(2)
#' )
#' @export

get_skater_statistics <- function(
  season=get_season_now()$seasonId,
  report='summary',
  teams=1:100,
  is_aggregate=FALSE,
  is_game=FALSE,
  dates=c('2025-01-01'),
  game_types=1:3
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
