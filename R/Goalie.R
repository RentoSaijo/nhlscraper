#' Get all goalies' biographies from a range of years
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return tibble with one row per goalie
#' @export

get_goalies <- function(start_year=1917, end_year=2025) {
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf("%04d", (start_year:(end_year-1))+1)
  )
  season_chunks <- split(seasons, ceiling(seq_along(seasons)/10))
  all_pages <- list()
  for (chunk in season_chunks) {
    min_season <- min(as.integer(chunk))
    max_season <- max(as.integer(chunk))
    out <- nhl_api(
      path="goalie/bios",
      query=list(
        isAggregate=T,
        limit=-1,
        start=0,
        sort="playerId",
        cayenneExp=sprintf("seasonId>=%d and seasonId<=%d", min_season, max_season)
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
  stats_sum <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::summarise(
      gamesPlayed=sum(gamesPlayed, na.rm=T),
      losses=sum(losses, na.rm=T),
      otLosses=sum(otLosses, na.rm=T),
      shutouts=sum(shutouts, na.rm=T),
      ties=sum(ties, na.rm=T),
      wins=sum(wins, na.rm=T),
      .groups="drop"
    )
  latest <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::slice_max(order_by=max_season_chunk, n=1 , with_ties=F) %>%
    dplyr::ungroup() %>%
    dplyr::select(-gamesPlayed, -losses, -otLosses, -shutouts, -ties, -wins)
  final <- latest %>%
    dplyr::left_join(stats_sum, by="playerId")
  return(final)
}

#' Get goalie stats leaders by season and game-type
#' 
#' @param season integer Season in YYYYYYYY
#' @param game_type integer Game-type where 2=regular and 3=playoffs
#' @param category string Category e.g. wins, shutouts, savePctg, goalsAgainstAverage
#' @return tibble with one row per goalie
#' @export

get_goalie_leaders <- function(
    season=20242025,
    game_type=2,
    category='wins'
  ) {
  out <- nhl_api(
    path=sprintf('goalie-stats-leaders/%s/%s', season, game_type),
    query=list(categories=category, limit=-1),
    stats_rest=F
  )
  return(tibble::as_tibble(out[[category]]))
}

#' Get goalie milestones
#' 
#' @return tibble with one row per goalie
#' @export

get_goalie_milestones <- function() {
  out <- nhl_api(
    path='milestones/goalies',
    query=list(),
    stats_rest=T
  )
  return(tibble::as_tibble(out$data))
}

#' Get skater statistics by season
#' 
#' @param season integer Season in YYYYYYYY
#' @param report string Report e.g. 'summary' and 'bios' (forced to 'summary' if
#'               `is_game`=T)
#' @param teams vector of integers TeamID(s)
#' @param is_aggregate boolean isAggregate where T=regular and playoffs combined
#'                     (or multiple seasons) from multiple teams, if applicable
#' @param is_game boolean isGame where T=rows by games and F=rows by players
#' @param dates vector of strings Date(s) in 'YYYY-MM-DD' (only if paired with
#'              `is_game`)
#' @return tibble with one row per skater or game
#' @export

get_goalie_statistics <- function(
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
      path='goalie/summary',
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
      stats_rest=T
    )
  }
  return(tibble::as_tibble(out$data))
}
