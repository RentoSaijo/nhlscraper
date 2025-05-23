#' Get all players' ids, first and last names, and multiplicities from
#' specified seasons
#' 
#' @importFrom magrittr %>%
#' @param start_year integer Year to start search
#' @param end_year integer Year to end search
#' @return dataframe with one row per player
#' @export

get_players <- function(start_year=1917, end_year=2025) {
  # build seasons
  seasons <- paste0(
    start_year:(end_year-1),
    sprintf("%04d", (start_year:(end_year-1)) + 1)
  )
  # placeholder for each season (regular & playoffs)
  all_players <- list()
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
      toi <- req_nhl(path, list(categories='toi', limit=-1))$toi
      # skip if empty
      if (is.null(toi) || nrow(toi) == 0) {
        next
      }
      # tibble for this batch
      df <- tibble::tibble(
        PlayerID=toi$id,
        FirstName=toi$`firstName.default`,
        LastName=toi$`lastName.default`
      )
      # append to all_players
      all_players[[length(all_players)+1]] <- df
    }
  }
  # combine, dedupe, and compute multiplicity
  dplyr::bind_rows(all_players) %>%
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
