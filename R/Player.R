#' Access all the players
#' 
#' `players()` scrapes all the players.
#' 
#' @returns data.frame with one row per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_players <- players()}
#' @export

players <- function() {
  players <- nhl_api(
    path = 'player',
    type = 'r'
  )$data
  players[order(players$id), ]
}

#' Access the season(s) and game type(s) in which a player played
#' 
#' `player_seasons()` scrapes the season(s) and game type(s) in which a 
#' player played in the NHL.
#' 
#' @param player integer ID (e.g., 8480039); see [players()] for reference
#' @returns data.frame with one row per season
#' @examples
#' Martin_Necas_seasons <- player_seasons(player = 8480039)
#' @export

player_seasons <- function(player = 8478402) {
  tryCatch(
    expr = {
      seasons <- nhl_api(
        path = sprintf('v1/player/%s/game-log/now', player),
        type = 'w'
      )$playerStatsSeasons
      seasons[0, ]
      seasons
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the summary for a player
#' 
#' `player_summary()` scrapes the summary for a given `player`.
#' 
#' @inheritParams player_seasons
#' @returns list with various items
#' @examples
#' Martin_Necas_summary <- player_summary(player = 8480039)
#' @export

player_summary <- function(player = 8478402) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/player/%s/landing', player),
        type = 'w'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the game log for a player, season, and game type
#' 
#' `player_game_log()` scrapes the game log for a given set of `player`, 
#' `season`, and `game_type`.
#'
#' @inheritParams player_seasons
#' @inheritParams roster_statistics
#' @returns data.frame with one row per game
#' @examples
#' Martin_Necas_game_log_regular_20242025 <- player_game_log(
#'   player    = 8480039,
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

player_game_log <- function(
  player    = 8478402, 
  season    = 'now', 
  game_type = ''
) {
  tryCatch(
    expr = {
      log <- nhl_api(
        path = sprintf(
          'v1/player/%s/game-log/%s/%s', 
          player, 
          season, 
          game_type
        ),
        type = 'w'
      )
      log$playerStatsSeasons[0, ]
      log$gameLog
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the spotlight players
#' 
#' `spotlight_players()` scrapes the spotlight players.
#'
#' @returns data.frame with one row per player
#' @examples
#' spotlight_players <- spotlight_players()
#' @export

spotlight_players <- function() {
  nhl_api(
    path = 'v1/player-spotlight',
    type = 'w'
  )
}
