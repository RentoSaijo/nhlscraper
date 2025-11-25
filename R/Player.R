#' Get all the players
#' 
#' `ns_players()` returns information on all the players, including but not limited to each player's ID, name, and bio-metrics.
#'
#' @returns data.frame with one row per player
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

#' Get the season(s) and game type(s) in which a player played
#' 
#' `ns_player_seasons()` returns the season(s) and game type(s) in which a player played in the NHL. Use [ns_players()] for `player` reference.
#' 
#' @param player integer ID (e.g., 8480039)
#' @returns data.frame with one row per season
#' @examples
#' Martin_Necas_seasons <- ns_player_seasons(player = 8480039)
#' @export

ns_player_seasons <- function(player = 8478402) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/player/%s/game-log/now', player),
        type = 'w'
      )$playerStatsSeasons
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the summary for a player
#' 
#' `ns_player_summary()` returns the summary for a given `player`, including but not limited to his ID, name, bio-metrics, and statistics. Use [ns_players()] for `player` reference.
#' 
#' @param player integer ID (e.g., 8480039)
#' @returns list with various items
#' @examples
#' Martin_Necas_landing <- ns_player_summary(player = 8480039)
#' @export

ns_player_summary <- function(player = 8478402) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/player/%s/landing', player),
        type = 'w'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the game log for a player, season, and game type
#' 
#' `ns_player_game_log()` returns the game log for a given set of `player`, `season`, and `game_type`, including but not limited to each game's ID, data, and his performance in it. Use [ns_players()] for `player` reference and [ns_seasons()] for `season` & `game_type` references.
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @returns data.frame with one row per game
#' @examples
#' Martin_Necas_gl_regular_20242025 <- ns_player_game_log(
#'   player    = 8480039,
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_player_game_log <- function(
  player    = 8478402, 
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the spotlight players
#' 
#' `ns_spotlight_players()` returns the spotlight players, including but not limited to each player's ID, name, and team.
#'
#' @returns data.frame with one row per player
#' @examples
#' spotlight_players <- ns_spotlight_players()
#' @export

ns_spotlight_players <- function() {
  nhl_api(
    path = 'v1/player-spotlight',
    type = 'w'
  )
}
