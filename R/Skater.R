#' Get all skaters' biographies from a range of seasons
#' 
#' @importFrom magrittr %>%
#' @param start_season integer Season to start search in YYYYYYYY
#' @param end_season integer Season to end search in YYYYYYYY
#' @return tibble with one row per skater
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
        isAggregate=T,
        limit=-1,
        start=0,
        sort='playerId',
        cayenneExp=sprintf('seasonId>=%d and seasonId<=%d', min_season, max_season)
      ),
      stats_rest=T
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
      assists=sum(assists, na.rm=T),
      gamesPlayed=sum(gamesPlayed, na.rm=T),
      goals=sum(goals, na.rm=T),
      points=sum(points, na.rm=T),
      .groups='drop'
    )
  latest <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::slice_max(order_by=max_season_chunk, n=1 , with_ties=F) %>%
    dplyr::ungroup() %>%
    dplyr::select(-assists, -gamesPlayed, -goals, -points, -max_season_chunk)
  final <- latest %>%
    dplyr::left_join(stats_sum, by='playerId') %>% 
    dplyr::select(-max_season_chunk)
  return(final)
}

#' Get skater statistics leaders by season and game-type
#' 
#' @param season integer Season in YYYYYYYY
#' @param game_type integer GameType where 2=regular and 3=playoffs
#' @param category string e.g. assists, goals, goalsSh, goalsPp, points, penaltyMins, toi, plusMinus, faceoffLeaders
#' @return tibble with one row per skater
#' @export

get_skater_leaders <- function(
    season=20242025,
    game_type=2,
    category='points'
  ) {
  out <- nhl_api(
    path=sprintf('skater-stats-leaders/%s/%s', season, game_type),
    query=list(categories=category, limit=-1),
    stats_rest=F
  )
  return(tibble::as_tibble(out[[category]]))
}

#' Get skater milestones
#' 
#' @return tibble with one row per skater
#' @export

get_skater_milestones <- function() {
  out <- nhl_api(
    path='milestones/skaters',
    query=list(),
    stats_rest=T
  )
  return(tibble::as_tibble(out$data))
}

#' Get skater statistics by season
#' 
#' @param season integer Season in YYYYYYYY
#' @param report string Report (check `get_configuration()` for possible inputs)
#' @param teams vector of integers TeamID(s)
#' @param is_aggregate boolean isAggregate where T=regular and playoffs combined
#'                     from multiple teams, if applicable
#' @param is_game boolean isGame where T=rows by games and F=rows by players
#' @param dates vector of strings Date(s) in 'YYYY-MM-DD' (only if paired with
#'              `is_game`; too many dates will result in incomplete data)
#' @return tibble with one row per skater or game
#' @export

get_skater_statistics <- function(
  season=20242025,
  report='summary',
  teams=1:100,
  is_aggregate=F,
  is_game=F,
  dates=c('2025-01-01'),
  game_types=1:3
  ) {
  if (is_game) {
    for (date in dates) {
      if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
        stop('date in `dates` must be in \'YYYY-MM-DD\' format', call.=F)
      }
    }
    out <- nhl_api(
      path=sprintf('skater/%s', report),
      query=list(
        limit=-1,
        isGame=T,
        cayenneExp=sprintf(
        'seasonId=%s and gameDate in (%s) and teamId in (%s) and gameTypeId in (%s)',
        season,
        paste0('\'', dates, '\'', collapse=','),
        paste(teams, collapse=','),
        paste(game_types, collapse=',')
        )
      ),
      stats_rest=T
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
      stats_rest=T
    )
  }
  return(tibble::as_tibble(out$data))
}
