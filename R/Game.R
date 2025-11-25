#' Access all the games
#' 
#' `games()` scrapes all the games.
#' 
#' @returns data.frame with one row per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_games <- games()}
#' @export

games <- function() {
  games <- nhl_api(
    path = 'en/game',
    type = 's'
  )$data
  games[order(games$id), ]
}

#' Access the scores for a date
#' 
#' `scores()` scrapes the scores for a given `date`.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @examples
#' scores_Halloween_2025 <- scores(date = '2025-10-31')
#' @export

scores <- function(date = 'now') {
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
#' `gc_summary()` scrapes the GC summary for a given `game`.
#' 
#' @param game integer ID (e.g., 2025020275); see [games()] for reference
#' @returns list of various items
#' @examples
#' gc_summary_Martin_Necas_legacy_game <- gc_summary(game = 2025020275)
#' @export

gc_summary <- function(game = 2023030417) {
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
#' `wsc_summary()` scrapes the WSC summary for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns list of various items
#' @examples
#' wsc_summary_Martin_Necas_legacy_game <- wsc_summary(game = 2025020275)
#' @export

wsc_summary <- function(game = 2023030417) {
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
#' `boxscore()` scrapes the boxscore for a given set of `game`, `team`, and 
#' `position`.
#' 
#' @inheritParams gc_summary
#' @inheritParams roster
#' @param team character of 'h'/'home' or 'a'/'away'
#' @returns data.frame with one row per player
#' @examples
#' boxscore_COL_forwards_Martin_Necas_legacy_game <- boxscore(
#'   game     = 2025020275,
#'   team     = 'H',
#'   position = 'F'
#' )
#' @export

boxscore <- function(
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
#' `game_rosters()` scrapes the rosters for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per player
#' @examples
#' rosters_Martin_Necas_legacy_game <- game_rosters(game = 2025020275)
#' @export

game_rosters <- function(game = 2023030417) {
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
#' `gc_play_by_play()` scrapes the GC play-by-play for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per event (play)
#' @examples
#' gc_pbp_Martin_Necas_legacy_game <- gc_play_by_play(game = 2025020275)
#' @export

gc_play_by_play <- function(game = 2023030417) {
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

#' @rdname gc_play_by_play
#' @export
gc_pbp <- function(game = 2023030417) {
  gc_play_by_play(game)
}

#' Access the World Showcase (WSC) play-by-play for a game
#' 
#' `wsc_play_by_play()` scrapes the WSC play-by-play for given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per event (play)
#' @examples
#' wsc_pbp_Martin_Necas_legacy_game <- wsc_play_by_play(game = 2025020275)
#' @export

wsc_play_by_play <- function(game = 2023030417) {
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

#' @rdname wsc_play_by_play
#' @export
wsc_pbp <- function(game = 2023030417) {
  wsc_play_by_play(game)
}

#' Access the shift charts for a game
#' 
#' `shifts()` scrapes the shift charts for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per shift
#' @examples
#' shifts_Martin_Necas_legacy_game <- shifts(game = 2025020275)
#' @export

shifts <- function(game = 2023030417) {
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
