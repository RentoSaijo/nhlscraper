#' Get all goalies' biographies by range of seasons
#' 
#' `get_goalies()` retrieves information about each goalie for a specified `start_season` and `end_season`, including but not limited to their ID, name, bio-metrics, and career statistics. This will soon become deprecated as `get_players()` can list all players and their IDs much quicker.
#' 
#' @importFrom magrittr %>%
#' @param start_season integer in YYYYYYYY
#' @param end_season integer in YYYYYYYY
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
#' `get_goalie_leaders()` retrieves information about each goalie for a specified `season`, `game_type`, and `category`, including but not limited to their ID, name, and statistics.
#' 
#' @param season integer in YYYYYYYY
#' @param game_type integer where 2=regular and 3=playoffs
#' @param category string of 'wins', 'shutouts', 'savePctg', or 
#'                 'goalsAgainstAverage'
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
    type=1
  )
  return(tibble::as_tibble(out[[category]]))
}

#' Get goalie milestones
#' 
#' `get_goalie_milestones()` retrieves information about each goalie close to a milestone, including but not limited to their ID, name, and statistics.
#' 
#' @return tibble with one row per goalie
#' @examples
#' goalie_milestones <- get_goalie_milestones()
#' @export

get_goalie_milestones <- function() {
  out <- nhl_api(
    path='milestones/goalies',
    query=list(),
    type=2
  )
  return(tibble::as_tibble(out$data))
}

#' Get goalie statistics by season
#' 
#' `get_goalie_statistics()` retrieves information about each goalie or game for (a) specified `season`, `teams`, `game_types`, and `report`. Check `get_configuration()` for what information each combination of `report`, `is_aggregate` and `is_game` can provide; `get_teams()` for team IDs; and `get_seasons()` for date references. `dates` must be specified when paired with `is_game` as the default range will return incomplete data (too wide); it will be ignored otherwise. Will soon be reworked for easier access.
#' 
#' @param season integer in YYYYYYYY
#' @param teams vector of integers Team ID(s)
#' @param game_types vector of integers where 1=pre-season, 2=regular, and 
#'                   3=playoffs
#' @param dates vector of strings in 'YYYY-MM-DD' *only if paired with `is_game`
#' @param report string
#' @param is_aggregate boolean
#' @param is_game boolean
#' @return tibble with one row per goalie or game
#' @examples
#' playoff_goalie_svr_20242025 <- get_goalie_statistics(
#'   season=20242025,
#'   teams=1:100,
#'   game_types=c(3),
#'   report='startedVsRelieved'
#' )
#' @export

get_goalie_statistics <- function(
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
      type=2
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
      type=2
    )
  }
  return(tibble::as_tibble(out$data))
}
