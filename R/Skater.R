#' Get all skaters' biographies from a range of years
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return tibble with one row per skater
#' @export

get_skaters <- function(start_year=1917, end_year=2025) {
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
      path="skater/bios",
      query=list(
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
      assists=sum(assists, na.rm=T),
      gamesPlayed=sum(gamesPlayed, na.rm=T),
      goals=sum(goals, na.rm=T),
      points=sum(points, na.rm=T),
      .groups="drop"
    )
  latest <- combined %>%
    dplyr::group_by(playerId) %>%
    dplyr::slice_max(order_by=max_season_chunk, n=1 , with_ties=F) %>%
    dplyr::ungroup() %>%
    dplyr::select(-assists, -gamesPlayed, -goals, -points, -max_season_chunk)
  final <- latest %>%
    dplyr::left_join(stats_sum, by="playerId")
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

#' Get skater statistics by c
#' 
#' @param report string Report e.g. bios and skaters
#' 
#' @return tibble with one row per skater/game
#' @export


