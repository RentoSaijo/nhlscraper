#' Access all the players
#'
#' `players()` retrieves all the players as a `data.frame` where each row represents player and includes detail on player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_players <- players()}
#' @export

players <- function() {
  tryCatch({
    players <- nhl_api(
      path = 'player',
      type = 'r'
    )$data
    players <- players[order(players$id), ]
    names(players)[names(players) == 'id']       <- 'playerId'
    names(players)[names(players) == 'position'] <- 'positionCode'
    names(players)[names(players) == 'centralRegistryPosition'] <- 'centralRegistryPositionCode'
    players
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the season(s) and game type(s) in which a player played
#'
#' `player_seasons()` retrieves the season(s) and game type(s) in which a player played as a `data.frame` where each row represents season and includes detail on date/season filtering windows and chronological context.
#'
#' @param player integer ID (e.g., 8480039); see [players()] for reference
#'
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
      seasons[[1]]
      names(seasons)[names(seasons) == 'season']    <- 'seasonId'
      names(seasons)[names(seasons) == 'gameTypes'] <- 'gameTypeIds'
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
#' `player_summary()` retrieves the summary for a player as a nested `list` that separates summary and detail blocks for player identity, role, handedness, and biographical profile.
#'
#' @inheritParams player_seasons
#'
#' @returns list with various items
#' @examples
#' Martin_Necas_summary <- player_summary(player = 8480039)
#' @export

player_summary <- function(player = 8478402) {
  tryCatch(
    expr = {
      summary <- nhl_api(
        path = sprintf('v1/player/%s/landing', player),
        type = 'w'
      )
      names(summary)[names(summary) == 'position'] <- 'positionCode'
      summary
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the game log for a player, season, and game type
#'
#' `player_game_log()` retrieves the game log for a player, season, and game type as a `data.frame` where each row represents game and includes detail on game timeline state, period/clock progression, and matchup flow plus production, workload, efficiency, and result-level performance outcomes.
#'
#' @inheritParams player_seasons
#' @inheritParams roster_statistics
#'
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
#' `spotlight_players()` retrieves the spotlight players as a `data.frame` where each row represents player and includes detail on team identity, affiliation, and matchup-side context plus player identity, role, handedness, and biographical profile.
#'
#' @returns data.frame with one row per player
#' @examples
#' spotlight_players <- spotlight_players()
#' @export

spotlight_players <- function() {
  tryCatch({
    players <- nhl_api(
      path = 'v1/player-spotlight',
      type = 'w'
    )
    names(players)[names(players) == 'position'] <- 'positionCode'
    players
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
