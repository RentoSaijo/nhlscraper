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
    sprintf('%04d', (start_year:(end_year-1))+1)
  )
  all_goalies <- list()
  season_chunks <- split(
    seasons,
    ceiling(seq_along(seasons)/25)
  )
  for (chunk in season_chunks) {
    min_season <- min(as.integer(chunk))
    max_season <- max(as.integer(chunk))
    cayenne <- sprintf('seasonId>=%d and seasonId<=%d', min_season, max_season)
    out <- nhl_api(
      path='goalie/bios',
      query=list(
        limit=-1,
        start=0,
        sort='playerId',
        cayenneExp=cayenne
      ),
      stats_rest=T
    )
    df <- tibble::as_tibble(out$data)
    if (nrow(df)>0) {
      all_goalies[[length(all_goalies)+1]] <- df
    }
  }
  dplyr::bind_rows(all_goalies) %>%
    dplyr::distinct(playerId, .keep_all=T)
}

#' Get goalie stats leaders for a season
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
