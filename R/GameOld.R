#' Access all the games
#' 
#' `get_games()` is deprecated. Use [ns_games()] instead.
#' 
#' @returns data.frame with one row per game
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

#' Access the scores for a date
#' 
#' `get_scores()` is deprecated. Use [ns_scores()] instead.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per game
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

#' Access the scoreboards for a date
#' 
#' `get_scoreboards()` is deprecated. Use [ns_scores()] instead.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per game
#' @export

get_scoreboards <- function(date = 'now') {
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

#' Access the GameCenter (GC) summary for a game
#' 
#' `get_game_landing()` is deprecated. Use [ns_gc_summary()] instead.
#'
#' @inheritParams ns_gc_summary
#' @returns list of various items
#' @export

get_game_landing <- function(game = 2023030417) {
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

#' Access the World Showcase (WSC) summary for a game
#' 
#' `get_game_story()` is deprecated. Use [ns_wsc_summary()] instead.
#'
#' @inheritParams ns_gc_summary
#' @returns list of various items
#' @export

get_game_story <- function(game = 2023030417) {
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

#' Access the boxscore for a game, team, and position
#' 
#' `get_game_boxscore()` is deprecated. Use [ns_boxscore()] instead.
#'
#' @inheritParams ns_gc_summary
#' @param team character of 'home' or 'away'
#' @param player_type character of 'forwards', 'defense', or 'goalies'
#' @returns data.frame with one row per player
#' @export

get_game_boxscore <- function(
    game        = 2023030417,
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

#' Access the GameCenter (GC) play-by-play for a game
#' 
#' `get_gc_play_by_play()` is deprecated. Use [ns_gc_play_by_play()] instead.
#'
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per event (play)
#' @export

get_gc_play_by_play <- function(game = 2023030417) {
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

#' Access the World Showcase (WSC) play-by-play for a game
#' 
#' `get_wsc_play_by_play()` is deprecated. Use [ns_wsc_play_by_play()] instead.
#'
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per event (play)
#' @export

get_wsc_play_by_play <- function(game = 2023030417) {
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

#' Access the shift charts for a game
#' 
#' `get_shift_charts()` is deprecated. Use [ns_shifts()] instead.
#'
#' @inheritParams ns_gc_summary
#' @returns data.frame with one row per shift
#' @export

get_shift_charts <- function(game = 2023030417) {
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
