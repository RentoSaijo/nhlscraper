#' Get all skaters' biographies from a range of years
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return dataframe with one row per player
#' @export

get_skaters <- function(start_year=1917, end_year=2025) {
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf("%04d", (start_year:(end_year-1))+1)
  )
  all_skaters <- list()
  season_chunks <- split(
    seasons,
    ceiling(seq_along(seasons)/25)
  )
  for (chunk in season_chunks) {
    min_season <- min(as.integer(chunk))
    max_season <- max(as.integer(chunk))
    cayenne <- sprintf("seasonId>=%d and seasonId<=%d", min_season, max_season)
    out <- nhl_api(
      path="skater/bios",
      query=list(
        limit=-1,
        start=0,
        sort="playerId",
        cayenneExp=cayenne
      ),
      stats_rest=T
    )
    df <- tibble::as_tibble(out$data)
    if (nrow(df)>0) {
      all_skaters[[length(all_skaters)+1]] <- df
    }
  }
  dplyr::bind_rows(all_skaters) %>%
    dplyr::distinct(playerId, .keep_all=T)
}

#' Get all goalies' biographies from a range of years
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return dataframe with one row per player
#' @export

get_goalies <- function(start_year=1917, end_year=2025) {
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf("%04d", (start_year:(end_year-1))+1)
  )
  all_skaters <- list()
  season_chunks <- split(
    seasons,
    ceiling(seq_along(seasons)/25)
  )
  for (chunk in season_chunks) {
    min_season <- min(as.integer(chunk))
    max_season <- max(as.integer(chunk))
    cayenne <- sprintf("seasonId>=%d and seasonId<=%d", min_season, max_season)
    out <- nhl_api(
      path="goalie/bios",
      query=list(
        limit=-1,
        start=0,
        sort="playerId",
        cayenneExp=cayenne
      ),
      stats_rest=T
    )
    df <- tibble::as_tibble(out$data)
    if (nrow(df)>0) {
      all_skaters[[length(all_skaters)+1]] <- df
    }
  }
  dplyr::bind_rows(all_skaters) %>%
    dplyr::distinct(playerId, .keep_all=T)
}

#' Get a player's game log for a season
#' 
#' @param player_id integer NHL player ID
#' @param season string Season in 'YYYYYYYY' e.g. 20242025
#' @param game_type integer 2=regular, 3=playoffs
#' @return tibble with one row per game
#' @export

get_player_game_log <- function(player_id, season=20242025, game_type=2) {
  path <- sprintf('player/%s/game-log/%s/%s', player_id, season, game_type)
  out <- nhl_api(path)
  return(tibble::as_tibble(out$gameLog))
}

#' Get a player's information
#' 
#' @param player_id integer NHL player ID
#' @return list with 36 items
#' @export

get_player_information <- function(player_id) {
  path <- sprintf('player/%s/landing', player_id)
  out <- nhl_api(path)
  return(out)
}

#' Get skater stats leaders for a season
#' 
#' @param season string Season in 'YYYYYYYY' e.g. 20242025
#' @param game_type integer 2=regular, 3=playoffs
#' @param category string e.g. assists, goals, goalsSh, goalsPp, points,
#' penaltyMins, toi, plusMinus, faceoffLeaders
#' (note that some are only available in recent years)
#' @return tibble with one row per skater
#' @export

get_skater_leaders <- function(
    season=20242025,
    game_type=2,
    category='points',
    limit=-1
  ) {
  path <- sprintf('skater-stats-leaders/%s/%s', season, game_type)
  out <- nhl_api(path, list(categories=category, limit=limit))
  return(tibble::as_tibble(out[[category]]))
}

#' Get goalie stats leaders for a season
#' 
#' @param season string Season in 'YYYYYYYY' e.g. 20242025
#' @param game_type integer 2=regular, 3=playoffs
#' @param category string e.g. wins, shutouts, savePctg, goalsAgainstAverage
#' (note that some are only available in recent years)
#' @return tibble with one row per skater
#' @export

get_goalie_leaders <- function(
    season=20242025,
    game_type=2,
    category='wins',
    limit=-1
  ) {
  path <- sprintf('goalie-stats-leaders/%s/%s', season, game_type)
  out <- nhl_api(path, list(categories=category, limit=limit))
  return(tibble::as_tibble(out[[category]]))
}

#' Get 'spotlight' players
#'
#' @return tibble with one row per skater
#' @export

get_spotlight_players <- function() {
  out <- nhl_api('player-spotlight')
  return(out)
}
