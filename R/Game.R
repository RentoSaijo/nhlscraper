#' Access all the games
#' 
#' `ns_games()` scrapes information on all the games.
#' 
#' @returns data.frame with one row per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_games <- ns_games()}
#' @export

ns_games <- function() {
  games <- nhl_api(
    path = 'en/game',
    type = 's'
  )$data
  games[order(games$id), ]
}

#' Access the scores for a date
#' 
#' `ns_scores()` scrapes the scores for a given `date`.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per game
#' @examples
#' scores_Halloween_2025 <- ns_scores(date = '2025-10-31')
#' @export

ns_scores <- function(date = 'now') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/score/%s', date),
        type = 'w'
      )$games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the GameCenter (GC) summary for a game
#' 
#' `ns_gc_summary()` scrapes the GC summary for a given `game`.
#' 
#' @param game integer ID (e.g., 2025020275); see [ns_games()] for reference
#' @returns list of various items
#' @examples
#' gc_summary_Martin_Necas_legacy_game <- ns_gc_summary(game = 2025020275)
#' @export

ns_gc_summary <- function(game = 2023030417) {
  tryCatch(
    expr = {
      landing    <- nhl_api(
        path = sprintf('v1/gamecenter/%s/landing', game),
        type = 'w'
      )
      right_rail <- nhl_api(
        path = sprintf('v1/gamecenter/%s/right-rail', game),
        type = 'w'
      )
      c(landing, right_rail)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the World Showcase (WSC) summary for a game
#' 
#' `ns_wsc_summary()` scrapes the WSC summary for a given `game`.
#' 
#' @inheritParams ns_gc_summary
#' @returns list of various items
#' @examples
#' wsc_summary_Martin_Necas_legacy_game <- ns_wsc_summary(game = 2025020275)
#' @export

ns_wsc_summary <- function(game = 2023030417) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/wsc/game-story/%s', game),
        type = 'w'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the boxscore for a game, team, and position
#' 
#' `ns_boxscore()` scrapes the boxscore for a given set of `game`, `team`, and 
#' `position`.
#' 
#' @inheritParams ns_gc_summary
#' @inheritParams ns_roster
#' @param team character of 'h'/'home' or 'a'/'away'
#' @returns data.frame with one row per player
#' @examples
#' boxscore_COL_forwards_Martin_Necas_legacy_game <- ns_boxscore(
#'   game     = 2025020275,
#'   team     = 'H',
#'   position = 'F'
#' )
#' @export

ns_boxscore <- function(
    game     = 2023030417,
    team     = 'home',
    position = 'forwards'
) {
  tryCatch(
    expr = {
      team <- switch(
        substring(tolower(team), 1, 1),
        h = 'home',
        a = 'away'
      )
      position <- switch(
        substring(tolower(position), 1, 1),
        f = 'forwards',
        d = 'defense',
        g = 'goalies'
      )
      boxscore <- nhl_api(
        path = sprintf('v1/gamecenter/%s/boxscore', game),
        type = 'w'
      )$playerByGameStats
      boxscore[[paste0(team, 'Team')]][[position]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the rosters for a game
#' 
#' `ns_game_rosters()` scrapes the rosters for a given `game`.
#' 
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per player
#' @examples
#' rosters_Martin_Necas_legacy_game <- ns_game_rosters(game = 2025020275)
#' @export

ns_game_rosters <- function(game = 2023030417) {
  tryCatch(
    expr = {
      rosters <- nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$rosterSpots
      rosters <- rosters[order(rosters$sweaterNumber), ]
      rosters[order(rosters$teamId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the GameCenter (GC) play-by-play for a game
#' 
#' `ns_gc_play_by_play()` scrapes GC play-by-play for a given `game`.
#' 
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per event (play)
#' @examples
#' gc_pbp_Martin_Necas_legacy_game <- ns_gc_play_by_play(game = 2025020275)
#' @export

ns_gc_play_by_play <- function(game = 2023030417) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$plays
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname ns_gc_play_by_play
#' @export
ns_gc_pbp <- function(game = 2023030417) {
  ns_gc_play_by_play(game)
}

#' Access the World Showcase (WSC) play-by-play for a game
#' 
#' `ns_wsc_play_by_play()` scrapes the WSC play-by-play for given `game`.
#' 
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per event (play)
#' @examples
#' wsc_pbp_Martin_Necas_legacy_game <- ns_wsc_play_by_play(game = 2025020275)
#' @export

ns_wsc_play_by_play <- function(game = 2023030417) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/wsc/play-by-play/%s', game),
        type = 'w'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname ns_wsc_play_by_play
#' @export
ns_wsc_pbp <- function(game = 2023030417) {
  ns_wsc_play_by_play(game)
}

#' Access the shift charts for a game
#' 
#' `ns_shifts()` scrapes the shift charts for a given `game`.
#' 
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per shift
#' @examples
#' shifts_Martin_Necas_legacy_game <- ns_shifts(game = 2025020275)
#' @export

ns_shifts <- function(game = 2023030417) {
  tryCatch(
    expr = {
      shifts <- nhl_api(
        path  = 'en/shiftcharts',
        query = list(cayenneExp = sprintf('gameId = %s', game)),
        type  = 's'
      )$data
      shifts[order(shifts$teamId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
