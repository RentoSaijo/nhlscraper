#' Get all the games
#' 
#' `ns_games()` retrieves information on each game, including but not limited 
#' to their ID, season, type, start date and time, and home and visiting teams' 
#' IDs and scores.
#' 
#' @return data.frame with one row per game
#' @examples
#' # This may take >5s, so skip.
#' \donttest{
#'   all_games <- ns_games()
#' }
#' @export

ns_games <- function() {
  nhl_api(
    path = 'en/game',
    type = 's'
  )$data
}

#' Get the score(s) of the game(s) for a date
#' 
#' `ns_scores()` retrieves information on each game for a given `date`, 
#' including but not limited to their ID; type; venue; start time; period and 
#' intermission clocks; and home and away teams' IDs, names, and scores. Access 
#' `get_seasons()` for `date` reference.
#' 
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01')
#' @return data.frame with one row per game
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the GameCenter (GC) summary of a game
#' 
#' `ns_gc_summary()` retrieves GC-provided information on a `game`, 
#' including but not limited to its type, venue, start time, clock, home and 
#' away teams, and TV broadcast(s). Access `get_games()` for `game` reference.
#' 
#' @param game integer ID (e.g., 2025020275)
#' @return list of various items
#' @examples
#' gc_summary_SCF_game_7_20232024 <- ns_gc_summary(game = 2023030417)
#' @export

ns_gc_summary <- function(game = 2025020275) {
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the World Showcase (WSC) summary of a game
#' 
#' `ns_wsc_summary()` retrieves WSC-provided information on a `game`, including 
#' but not limited to its type, venue, start time, clock, home and away teams, 
#' and TV broadcast(s). Access `get_games()` for `game` reference.
#' 
#' @param game integer ID (e.g., 2025020275)
#' @return list of various items
#' @examples
#' wsc_summary_SCF_game_7_20232024 <- ns_wsc_summary(game = 2023030417)
#' @export

ns_wsc_summary <- function(game = 2025020275) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/wsc/game-story/%s', game),
        type = 'w'
      )
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the boxscore of a game for a team and position
#' 
#' `ns_boxscore()` retrieves information on each player for a given set 
#' of `game`, `team`, and `player_type`, including but not limited to their ID, 
#' name, sweater number, goals, assists, +/-, hits, blocks, shots-on-goal, 
#' giveaways, takeaways, time on ice, and number of shifts. Access 
#' `get_games()` for `game` reference.
#' 
#' @param game integer ID (e.g., 2025020275)
#' @param team character of 'h'/'home' or 'a'/'away'
#' @param position character of 'f'/'forwards', 'd'/'defensemen', or 
#' 'g'/goalies'
#' @return data.frame with one row per player
#' @examples
#' boxscore_SCF_game_7_20232024_FLA_defensemen <- ns_boxscore(
#'   game     = 2023030417,
#'   team     = 'A',
#'   position = 'D'
#' )
#' @export

ns_boxscore <- function(
    game     = 2025020275,
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the rosters of a game
#' 
#' `ns_game_rosters()` retrieves ...
#' 
#' @param game integer ID (e.g., 2025020275)
#' @return data.frame with one row per player
#' @examples
#' rosters_SCF_game_7_20232024 <- ns_game_rosters(game = 2023030417)
#' @export

ns_game_rosters <- function(game = 2025020275) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$rosterSpots
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the GameCenter (GC) play-by-play of a game
#' 
#' `ns_gc_play_by_play()` retrieves GC-provided information on each play for a 
#' given `game`, including but not limited to their ID; type; time of 
#' occurrence; winning, losing, blocking, shooting, hitting, hit, scoring, 
#' assisting, committed-by, drawn-by, and/or served-by player IDs; and X and Y 
#' coordinates. Access `get_games()` for `game` reference.
#' 
#' @param game integer ID (e.g., 2025020275)
#' @return data.frame with one row per event/play
#' @examples
#' gc_pbp_SCF_game_7_20232024 <- ns_gc_play_by_play(game = 2023030417)
#' @export

ns_gc_play_by_play <- function(game = 2025020275) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$plays
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' @rdname ns_gc_play_by_play
#' @export
ns_gc_pbp <- function(game = 2025020275) {
  ns_gc_pbp(game)
}

#' Get the World Showcase (WSC) play-by-play of a game
#' 
#' `ns_wsc_play_by_play()` retrieves WSC-provided information on each play for a given `game`, including but not limited to their ID; time and strength state of occurrence; winning, losing, blocking, shooting, hitting, hit, scoring, assisting, committed-by, drawn-by, and/or served-by player IDs; and X and Y coordinates. Access `get_games()` for `game` reference.
#'
#' @param game integer ID (e.g., 2025020275)
#' @return data.frame with one row per event/play
#' @examples
#' wsc_pbp_SCF_game_7_20232024 <- ns_wsc_play_by_play(game = 2023030417)
#' @export

ns_wsc_play_by_play <- function(game = 2025020275) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/wsc/play-by-play/%s', game),
        type = 'w'
      )
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' @rdname ns_wsc_play_by_play
#' @export
ns_wsc_pbp <- function(game = 2025020275) {
  ns_wsc_pbp(game)
}

#' Get the shifts of a game
#' 
#' `ns_shifts()` retrieves information on each shift for a given `game`, 
#' including but not limited to their period, start and end times, and player's 
#' ID and name. Access `get_games()` for `game` reference.
#' 
#' @param game integer ID (e.g., 2025020275)
#' @return data.frame with one row per shift
#' @examples
#' shifts_SCF_game_7_20232024 <- ns_shifts(game = 2023030417)
#' @export

ns_shifts <- function(game = 2025020275) {
  tryCatch(
    expr = {
      nhl_api(
        path  = 'en/shiftcharts',
        query = list(cayenneExp = sprintf('gameId = %s', game)),
        type  = 's'
      )$data
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
