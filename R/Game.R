#' Get score(s) by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
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
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out$games))
}

#' Get scoreboard(s) by date
#' 
#' @param date string Date in 'YYYY-MM-DD'
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
    query=list(),
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
#' @param game integer Game ID
#' @return tibble with one row per play
#' @examples
#' gc_pbp_2024030411 <- get_gc_play_by_play(game=2024030411)
#' @export

get_gc_play_by_play <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/play-by-play', game),
    query=list(),
    type=1
  )
  return(tibble::as_tibble(out$plays))
}

#' Get World Showcase (WSC) play-by-play by game
#' 
#' @param game integer Game ID
#' @return tibble with one row per play
#' @examples
#' wsc_pbp_2024030411 <- get_wsc_play_by_play(game=2024030411)
#' @export

get_wsc_play_by_play <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('wsc/play-by-play/%s', game),
    query=list(),
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
#' @param game integer Game ID
#' @param team string Team of 'home' or 'away'
#' @param player_type string Player-type of 'forwards', 'defense', or 'goalies'
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
    query=list(),
    type=1
  )
  return(tibble::as_tibble(
    out$playerByGameStats[[paste0(team, 'Team')]][[player_type]])
  )
}

#' Get GC game landing by game
#' 
#' @param game integer Game ID
#' @return list of 24 items
#' @examples
#' game_landing_2024030411 <- get_game_landing(game=2024030411)
#' @export

get_game_landing <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('gamecenter/%s/landing', game),
    query=list(),
    type=1
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get WSC game story by game
#' 
#' @param game integer Game ID
#' @return list of 24 items
#' @examples
#' game_story_2024030411 <- get_game_story(game=2024030411)
#' @export

get_game_story <- function(game=2024020602) {
  out <- nhl_api(
    path=sprintf('wsc/game-story/%s', game),
    query=list(),
    type=1
  )
  if (length(out)==4) {
    return(list())
  }
  return(out)
}

#' Get all games
#' 
#' @return tibble with one row per game
#' @examples
#' all_games <- get_games()
#' @export

get_games <- function() {
  out <- nhl_api(
    path='game',
    query=list(),
    type=2
  )
  return(tibble::as_tibble(out$data))
}

#' Get shift charts
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
