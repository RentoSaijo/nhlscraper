#' Get all goalies' biographies by range of seasons
#' 
#' @importFrom magrittr %>%
#' @param start_season integer Season to start search in YYYYYYYY
#' @param end_season integer Season to end search in YYYYYYYY
#' @return tibble with one row per goalie
#' @examples
#' goalies_2000s <- get_goalies(start_season=20002001, end_season=20242025)
#' @export

get_goalies <- function(
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
      path='goalie/bios',
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
      stats_rest=TRUE
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
      gamesPlayed=sum(gamesPlayed, na.rm=TRUE),
      losses=sum(losses, na.rm=TRUE),
      otLosses=sum(otLosses, na.rm=TRUE),
      shutouts=sum(shutouts, na.rm=TRUE),
      ties=sum(ties, na.rm=TRUE),
      wins=sum(wins, na.rm=TRUE),
      .groups='drop'
    )
  latest <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::slice_max(order_by=max_season_chunk, n=1 , with_ties=FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      -gamesPlayed,
      -losses,
      -otLosses,
      -shutouts,
      -ties,
      -wins,
      -max_season_chunk
    )
  final <- latest %>%
    dplyr::left_join(stats_sum, by='playerId')
  return(final)
}

#' Get goalie statistics leaders by season, game-type, and category
#' 
#' @param season integer Season in YYYYYYYY
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @param category string Category e.g. wins, shutouts, savePctg,
#'                 goalsAgainstAverage
#' @return tibble with one row per goalie
#' @examples
#' playoff_savePctg_leaders_20242025 <- get_goalie_leaders(
#'   season=20242025,
#'   game_type=3,
#'   category='savePctg'
#' )
#' @export

get_goalie_leaders <- function(
    season=get_season_now()$seasonId,
    game_type=2,
    category='wins'
  ) {
  out <- nhl_api(
    path=sprintf('goalie-stats-leaders/%s/%s', season, game_type),
    query=list(categories=category, limit=-1),
    stats_rest=FALSE
  )
  return(tibble::as_tibble(out[[category]]))
}

#' Get goalie milestones
#' 
#' @return tibble with one row per goalie
#' @examples
#' goalie_milestones <- get_goalie_milestones()
#' @export

get_goalie_milestones <- function() {
  out <- nhl_api(
    path='milestones/goalies',
    query=list(),
    stats_rest=TRUE
  )
  return(tibble::as_tibble(out$data))
}

#' Get goalie statistics by season
#' 
#' @param season integer Season in YYYYYYYY
#' @param report string Report (check `get_configuration()` for possible inputs)
#' @param teams vector of integers Team ID(s)
#' @param is_aggregate boolean isAggregate where TRUE=regular and playoffs
#'                     combined (or multiple seasons) from multiple teams,
#'                     if applicable
#' @param is_game boolean isGame where TRUE=rows by games and FALSE=rows by
#'                goalies
#' @param dates vector of strings Date(s) in 'YYYY-MM-DD' (only if paired with
#'              `is_game`)
#' @param game_types vector of integers Game-type(s) where 1=pre-season,
#'                   2=regular, and 3=playoffs
#' @return tibble with one row per goalie or game
#' @examples
#' playoff_goalie_svr_20242025 <- get_goalie_statistics(
#'   season=20242025,
#'   report='startedVsRelieved',
#'   game_types=c(3)
#' )
#' @export

get_goalie_statistics <- function(
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
      path=sprintf('goalie/%s', report),
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
      stats_rest=TRUE
    )
  }
  else {
    out <- nhl_api(
      path=sprintf('goalie/%s', report),
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
      stats_rest=TRUE
    )
  }
  return(tibble::as_tibble(out$data))
}
