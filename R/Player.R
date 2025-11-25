#' Access all the players
#' 
#' `ns_players()` scrapes information on all the players.
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

#' Access the season(s) and game type(s) in which a player played
#' 
#' `ns_player_seasons()` scrapes the season(s) and game type(s) in which a 
#' player played in the NHL.
#' 
#' @param player integer ID (e.g., 8480039); see [ns_players()] for reference
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

#' Access the summary for a player
#' 
#' `ns_player_summary()` scrapes the summary for a given `player`.
#' 
#' @inheritParams ns_player_seasons
#' @returns list with various items
#' @examples
#' Martin_Necas_summary <- ns_player_summary(player = 8480039)
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

#' Access the game log for a player, season, and game type
#' 
#' `ns_player_game_log()` scrapes the game log for a given set of `player`, 
#' `season`, and `game_type`.
#'
#' @inheritParams ns_player_seasons
#' @inheritParams ns_roster_statistics
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

#' Access the spotlight players
#' 
#' `ns_spotlight_players()` scrapes the spotlight players.
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
