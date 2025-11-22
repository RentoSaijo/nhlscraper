#' Get all the games
#' 
#' `get_games()` is deprecated. Use [ns_games()] instead.
#' 
#' @export

get_games <- function() {
  .Deprecated(
    new     = 'ns_games()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_games()` is deprecated.',
      'Use `ns_games()` instead.'
    )
  )
  ns_games()
}

#' Get the score(s) of the game(s) for a date
#' 
#' `get_scores()` is deprecated. Use [ns_scores()] instead.
#' 
#' @export

get_scores <- function(date = 'now') {
  .Deprecated(
    new     = 'ns_scores()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_scores()` is deprecated.',
      'Use `ns_scores()` instead.'
    )
  )
  ns_scores(date)
}

#' Get the scoreboard(s) of the game(s) for a date
#' 
#' `get_scoreboards()` is deprecated. Use [ns_scores()] instead.
#' 
#' @export

get_scoreboards <- function(date='2025-01-01') {
  .Deprecated(
    new     = 'ns_scores()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_scoreboards()` is deprecated.',
      'Use `ns_scores()` instead.'
    )
  )
  ns_scores(date)
}

#' Get the boxscore of a game for a team and player type
#' 
#' `get_game_boxscore()` is deprecated. Use [ns_boxscore()] instead.
#'
#' @export

get_game_boxscore <- function(
    game        = 2025020275,
    team        = 'home',
    player_type = 'forwards'
) {
  .Deprecated(
    new     = 'ns_boxscore()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_game_boxscore()` is deprecated.',
      'Use `ns_boxscore()` instead.'
    )
  )
  ns_boxscore(game, team, player_type)
}

#' Get the GameCenter (GC) play-by-play of a game
#' 
#' `get_gc_play_by_play()` is deprecated. Use [ns_gc_play_by_play()] instead.
#'
#' @export

get_gc_play_by_play <- function(game = 2025020275) {
  .Deprecated(
    new     = 'ns_gc_play_by_play()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_gc_play_by_play()` is deprecated.',
      'Use `ns_gc_play_by_play()` instead.'
    )
  )
  ns_gc_play_by_play(game)
}

#' Get the World Showcase (WSC) play-by-play of a game
#' 
#' `get_wsc_play_by_play()` is deprecated. Use [ns_wsc_play_by_play()] instead.
#'
#' @export

get_wsc_play_by_play <- function(game = 2025020275) {
  .Deprecated(
    new     = 'ns_wsc_play_by_play()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_wsc_play_by_play()` is deprecated.',
      'Use `ns_wsc_play_by_play()` instead.'
    )
  )
  ns_wsc_play_by_play(game)
}

#' Get the shifts of a game
#' 
#' `get_shift_charts()` is deprecated. Use [ns_shifts()] instead.
#'
#' @export

get_shift_charts <- function(game = 2025020275) {
  .Deprecated(
    new     = 'ns_shifts()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_shift_charts()` is deprecated.',
      'Use `ns_shifts()` instead.'
    )
  )
  ns_shifts(game)
}

#' Get the GameCenter (GC) summary of a game
#' 
#' `get_game_landing()` is deprecated. Use [ns_gc_summary()] instead.
#'
#' @export

get_game_landing <- function(game = 2025020275) {
  .Deprecated(
    new     = 'ns_gc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_game_landing()` is deprecated.',
      'Use `ns_gc_summary()` instead.'
    )
  )
  ns_gc_summary(game)
}

#' Get the World Showcase (WSC) summary of a game
#' 
#' `get_game_story()` is deprecated. Use [ns_wsc_summary()] instead.
#'
#' @export

get_game_story <- function(game = 2025020275) {
  .Deprecated(
    new     = 'ns_wsc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_game_story()` is deprecated.',
      'Use `ns_wsc_summary()` instead.'
    )
  )
  ns_wsc_summary(game)
}
