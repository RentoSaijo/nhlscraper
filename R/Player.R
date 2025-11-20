#' Get all the players
#' 
#' `ns_players()` retrieves information on each player, including but not 
#' limited to their ID, name, bio-metrics, birth date and location, and 
#' hall-of-fame status.
#'
#' @return data.frame with one row per player
#' @examples
#' # This may take >5s, so skip.
#' \donttest{all_players <- ns_players()}
#' @export

ns_players <- function() {
  players <- nhl_api(
    path = 'player',
    type = 'r'
  )$data
  players[order(players$id), ]
}

#' Get the season(s) and game type(s) of which a player played in
#' 
#' `ns_player_seasons()` retrieves information ...
#' 
#' @param player integer ID (e.g., 8480039)
#' @return data.frame with one row per season
#' @examples
#' Martin_Necas_seasons <- ns_player_seasons(player = 8480039)
#' @export

ns_player_seasons <- function(player = 8480039) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/player/%s/game-log/now', player),
        type = 'w'
      )$playerStatsSeasons
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the summary of a player
#' 
#' `ns_player_summary()` retrieves information on a `player`, including but not 
#' limited to his ID, name, bio-metrics, career statistics, and awards. Access 
#' `get_players()` for `player` reference.
#' 
#' @param player integer ID (e.g., 8480039)
#' @return list with various items
#' @examples
#' Martin_Necas_landing <- ns_player_summary(player = 8480039)
#' @export

ns_player_summary <- function(player = 8480039) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/player/%s/landing', player),
        type = 'w'
      )
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the game log of a player for a season and game type
#' 
#' `ns_player_game_log()` retrieves information on each game for a given set of 
#' `player`, `season`, and `game_type`, including but not limited to their ID, 
#' date, and statistics. Access `get_players()` for `player` and `get_seasons()` 
#' for `season` references.
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return data.frame with one row per game
#' @examples
#' Martin_Necas_gl_regular_20242025 <- ns_player_game_log(
#'   player    = 8480039,
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_player_game_log <- function(
    player    = 8480039, 
    season    = 'now', 
    game_type = ''
) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/player/%s/game-log/%s/%s', 
          player, 
          season, 
          game_type
        ),
        type = 'w'
      )$gameLog
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the spotlight players
#' 
#' `ns_spotlight_players()` retrieves information on each 'spotlight' player, 
#' including but not limited to their ID, name, position, and sweater number.
#'
#' @return data.frame with one row per player
#' @examples
#' spotlight_players <- ns_spotlight_players()
#' @export

ns_spotlight_players <- function() {
  nhl_api(
    path = 'v1/player-spotlight',
    type = 'w'
  )
}
