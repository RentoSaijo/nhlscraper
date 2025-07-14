#' Get score(s) by date
#' 
#' `get_scores()` returns live information about each game for a specified `date`, including but not limited to their ID; type; venue; start time; period and intermission clocks; and home and away teams' IDs, names, and scores.
#' 
#' @param date string in 'YYYY-MM-DD'
#' @return tibble with one row per game
#' @examples
#' scores_2025_01_02 <- get_scores(date='2025-01-02')
#' @export

get_scores <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=FALSE)
  }
  out <- nhl_api(
    path=sprintf('score/%s', date),
    type=1
  )
  return(tibble::as_tibble(out$games))
}

#' Get scoreboard(s) by date
#' 
#' `get_scoreboards()` returns information about each game for a specified `date`, including but not limited to their ID; type; venue; start time; tickets link; and home and away teams' IDs, names, and scores. Unable to conclude any major difference between this and `get_scores()`; may become deprecated in the future.
#' 
#' @param date string in 'YYYY-MM-DD'
#' @return tibble with one row per game
#' @examples
#' scoreboards_2025_01_02 <- get_scoreboards(date='2025-01-02')
#' @export

get_scoreboards <- function(date='2025-01-01') {
  if (!grepl('^\\d{4}-\\d{2}-\\d{2}$', date)) {
    stop('`date` must be in \'YYYY-MM-DD\' format', call.=FALSE)
  }
  out <- nhl_api(
    path=sprintf('scoreboard/%s', date),
    type=1
  )
  if (is.null(out$gamesByDate)) {
    return(tibble::tibble())
  }
  sub <- out$gamesByDate[out$gamesByDate$date==date, , drop=FALSE]
  if (nrow(sub)==0) {
    return(tibble::tibble())
  }
  tibble::as_tibble(sub$games[[1]])
}

#' Get GameCenter (GC) play-by-play by game
#' 
#' `get_gc_play_by_play()` retrieves GC-provided information about each play for a specified `game`, including but not limited to their ID; type; time of occurrence; winning, losing, blocking, shooting, hitting, hit, scoring, assisting, committed-by, drawn-by, and/or served-by player IDs; and X and Y coordinates. There exists many methods to grab game IDs; the easiest is by using `get_games()`.
#' 
#' @param game integer Game ID
#' @return tibble with one row per play
#' @examples
#' gc_pbp_2024030411 <- get_gc_play_by_play(game=2024030411)
#' @export

get_gc_play_by_play <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/play-by-play', game),
    type=1
  )
  return(tibble::as_tibble(out$plays))
}

#' Get World Showcase (WSC) play-by-play by game
#' 
#' `get_wsc_play_by_play()` retrieves WSC-provided information about each play for a specified `game`, including but not limited to their ID; time and strength state of occurrence; winning, losing, blocking, shooting, hitting, hit, scoring, assisting, committed-by, drawn-by, and/or served-by player IDs; and X and Y coordinates. There exists many methods to grab game IDs; the easiest is by using `get_games()`.
#'
#' @param game integer Game ID
#' @return tibble with one row per play
#' @examples
#' wsc_pbp_2024030411 <- get_wsc_play_by_play(game=2024030411)
#' @export

get_wsc_play_by_play <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('wsc/play-by-play/%s', game),
    type=1
  )
  out <- tibble::as_tibble(out)
  if (ncol(out)==4) {
    return(tibble::tibble())
  }
  return(out)
}

#' Get boxscore by game, team, and player-type
#' 
#' `get_game_boxscore()` retrieves information about each player for a specified `game`, `team`, and `player_type`, including but not limited to their ID, name, sweater number, goals, assists, +/-, hits, blocks, shots-on-goal, giveaways, takeaways, time on ice, and number of shifts. There exists many methods to grab game IDs; the easiest is by using `get_games()`.
#' 
#' @param game integer Game ID
#' @param team string of 'home' or 'away'
#' @param player_type string of 'forwards', 'defense', or 'goalies'
#' @return tibble with one row per player
#' @examples
#' boxscore_2024030411_FLA_defensemen <- get_game_boxscore(
#'   game=2024030411,
#'   team='away',
#'   player_type='defense'
#' )
#' @export

get_game_boxscore <- function(
    game=2024020602,
    team='home',
    player_type='forwards'
  ) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/boxscore', game),
    type=1
  )
  return(tibble::as_tibble(
    out$playerByGameStats[[paste0(team, 'Team')]][[player_type]])
  )
}

#' Get GameCenter (GC) game-landing by game
#' 
#' `get_game_landing()` retrieves GC-provided information about a `game`, including but not limited to its type, venue, start time, clock, home and away teams, and TV broadcast(s). There exists many methods to grab game IDs; the easiest is by using `get_games()`.
#' 
#' @param game integer Game ID
#' @return list of various items
#' @examples
#' game_landing_2024030411 <- get_game_landing(game=2024030411)
#' @export

get_game_landing <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/landing', game),
    type=1
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get World Showcase (WSC) game-story by game
#' 
#' `get_game_story()` retrieves WSC-provided information about a `game`, including but not limited to its type, venue, start time, clock, home and away teams, and TV broadcast(s). There exists many methods to grab game IDs; the easiest is by using `get_games()`.
#' 
#' @param game integer Game ID
#' @return list of various items
#' @examples
#' game_story_2024030411 <- get_game_story(game=2024030411)
#' @export

get_game_story <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('wsc/game-story/%s', game),
    type=1
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get all games
#' 
#' `get_games()` retrieves information about each game, including but not limited to their ID, season, type, date, start time, home and visiting teams' IDs and scores.
#' 
#' @return tibble with one row per game
#' @examples
#' all_games <- get_games()
#' @export

get_games <- function() {
  out <- nhl_api(
    path='game',
    type=2
  )
  return(tibble::as_tibble(out$data))
}

#' Get shift charts
#' 
#' `get_shift_charts()` retrieves information about each shift for a specified `game`, including but not limited to their period, start and end times, and player's ID and name. There exists many methods to grab game IDs; the easiest is by using `get_games()`.
#' 
#' @param game integer Game ID
#' @return tibble with one row per shift
#' @examples
#' shift_charts_2024030411 <- get_shift_charts(game=2024030411)
#' @export

get_shift_charts <- function(game=2024020602) {
  out <- nhl_api(
    path='shiftcharts',
    query=list(cayenneExp=sprintf('gameId=%s', game)),
    type=2
  )
  return(tibble::as_tibble(out$data))
}
