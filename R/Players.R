#' Get all skaters' ids, first and last names, and multiplicities from
#' specified seasons (who have at least scored 1 point)
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return dataframe with one row per player
#' @export

get_skaters <- function(start_year=1917, end_year=2025) {
  # build seasons
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf("%04d", (start_year:(end_year-1))+1)
  )
  # placeholder for each season (regular & playoffs)
  all_skaters <- list()
  # loop through seasons (regular & playoffs)
  for (season in seasons) {
    for (rp in c(2, 3)) {
      # endpoint path
      path <- paste0(
        'skater-stats-leaders/',
        season,
        '/',
        rp
      )
      # hit API
      pts <- req_nhl(path, list(categories='points', limit=-1))$points
      # skip if empty
      if (is.null(pts) || nrow(pts)==0) {
        next
      }
      # tibble for this batch
      df <- tibble::tibble(
        PlayerID=pts$id,
        FirstName=pts$`firstName.default`,
        LastName=pts$`lastName.default`
      )
      # append to all_skaters
      all_skaters[[length(all_skaters)+1]] <- df
    }
  }
  # combine, dedupe, and compute multiplicity
  dplyr::bind_rows(all_skaters) %>%
    dplyr::distinct(PlayerID, FirstName, LastName) %>%
    dplyr::group_by(FirstName, LastName) %>%
    dplyr::arrange(PlayerID, .by_group=T) %>%
    dplyr::mutate(Multiplicity = dplyr::row_number()) %>%
    dplyr::ungroup() %>% 
    dplyr::arrange(PlayerID)
}

#' Get all goalies' ids, first and last names, and multiplicities from
#' specified seasons (who have at least earned 1 win)
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return dataframe with one row per player
#' @export

get_goalies <- function(start_year=1917, end_year=2025) {
  # same logic as get_skaters()
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf("%04d", (start_year:(end_year-1)) + 1)
  )
  all_goalies <- list()
  for (season in seasons) {
    for (rp in c(2, 3)) {
      path <- paste0(
        'goalie-stats-leaders/',
        season,
        '/',
        rp
      )
      wins <- req_nhl(path, list(categories='wins', limit=-1))$wins
      if (is.null(wins) || nrow(wins) == 0) {
        next
      }
      df <- tibble::tibble(
        PlayerID=wins$id,
        FirstName=wins$`firstName.default`,
        LastName=wins$`lastName.default`
      )
      all_goalies[[length(all_goalies)+1]] <- df
    }
  }
  dplyr::bind_rows(all_goalies) %>%
    dplyr::distinct(PlayerID, FirstName, LastName) %>%
    dplyr::group_by(FirstName, LastName) %>%
    dplyr::arrange(PlayerID, .by_group=T) %>%
    dplyr::mutate(Multiplicity = dplyr::row_number()) %>%
    dplyr::ungroup() %>% 
    dplyr::arrange(PlayerID)
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
  out <- req_nhl(path)
  return(tibble::as_tibble(out$gameLog))
}

#' Get a player's information
#' 
#' @param player_id integer NHL player ID
#' @return list with 36 items
#' @export

get_player_information <- function(player_id) {
  path <- sprintf('player/%s/landing', player_id)
  out <- req_nhl(path)
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
  out <- req_nhl(path, list(categories=category, limit=limit))
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
  out <- req_nhl(path, list(categories=category, limit=limit))
  return(tibble::as_tibble(out[[category]]))
}