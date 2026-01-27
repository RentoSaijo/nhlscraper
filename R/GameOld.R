#' Access all the games
#' 
#' `get_games()` is deprecated. Use [games()] instead.
#' 
#' @returns data.frame with one row per game
#' @export

get_games <- function() {
  .Deprecated(
    new     = 'games()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_games()` is deprecated.',
      'Use `games()` instead.'
    )
  )
  games()
}

#' Access the scores for a date
#' 
#' `get_scores()` is deprecated. Use [scores()] instead.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @export

get_scores <- function(date = 'now') {
  .Deprecated(
    new     = 'scores()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_scores()` is deprecated.',
      'Use `scores()` instead.'
    )
  )
  scores(date)
}

#' Access the scoreboards for a date
#' 
#' `get_scoreboards()` is deprecated. Use [scores()] instead.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @export

get_scoreboards <- function(date = 'now') {
  .Deprecated(
    new     = 'scores()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_scoreboards()` is deprecated.',
      'Use `scores()` instead.'
    )
  )
  scores(date)
}

#' Access the GameCenter (GC) summary for a game
#' 
#' `get_game_landing()` is deprecated. Use [gc_summary()] instead.
#'
#' @inheritParams gc_summary
#' @returns list of various items
#' @export

get_game_landing <- function(game = 2023030417) {
  .Deprecated(
    new     = 'gc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_game_landing()` is deprecated.',
      'Use `gc_summary()` instead.'
    )
  )
  gc_summary(game)
}

#' Access the World Showcase (WSC) summary for a game
#' 
#' `get_game_story()` is deprecated. Use [wsc_summary()] instead.
#'
#' @inheritParams gc_summary
#' @returns list of various items
#' @export

get_game_story <- function(game = 2023030417) {
  .Deprecated(
    new     = 'wsc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_game_story()` is deprecated.',
      'Use `wsc_summary()` instead.'
    )
  )
  wsc_summary(game)
}

#' Access the boxscore for a game, team, and player type
#' 
#' `get_game_boxscore()` is deprecated. Use [boxscore()] instead.
#'
#' @inheritParams gc_summary
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
    new     = 'boxscore()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_game_boxscore()` is deprecated.',
      'Use `boxscore()` instead.'
    )
  )
  boxscore(game, team, player_type)
}

#' Access the GameCenter (GC) play-by-play for a game
#' 
#' `get_gc_play_by_play()` is deprecated. Use [gc_play_by_play()] instead.
#'
#' @inheritParams gc_summary
#' @returns data.frame with one row per event (play)
#' @export

get_gc_play_by_play <- function(game = 2023030417) {
  .Deprecated(
    new     = 'gc_play_by_play()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_gc_play_by_play()` is deprecated.',
      'Use `gc_play_by_play()` instead.'
    )
  )
  gc_play_by_play(game)
}

#' Access the World Showcase (WSC) play-by-play for a game
#' 
#' `get_wsc_play_by_play()` is deprecated. Use [wsc_play_by_play()] instead.
#'
#' @inheritParams gc_summary
#' @returns data.frame with one row per event (play)
#' @export

get_wsc_play_by_play <- function(game = 2023030417) {
  .Deprecated(
    new     = 'wsc_play_by_play()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_wsc_play_by_play()` is deprecated.',
      'Use `wsc_play_by_play()` instead.'
    )
  )
  wsc_play_by_play(game)
}

#' Access the shift charts for a game
#' 
#' `get_shift_charts()` is deprecated. Use [shift_chart()] instead.
#'
#' @inheritParams gc_summary
#' @returns data.frame with one row per shift
#' @export

get_shift_charts <- function(game = 2023030417) {
  .Deprecated(
    new     = 'shift_chart()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_shift_charts()` is deprecated.',
      'Use `shift_chart()` instead.'
    )
  )
  shift_chart(game)
}

#' Access the shift charts for a game
#' 
#' `shifts()` is deprecated. Use [shift_chart()] instead.
#'
#' @inheritParams gc_summary
#' @returns data.frame with one row per shift
#' @export

shifts <- function(game = 2023030417) {
  .Deprecated(
    new     = 'shift_chart()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_shift_charts()` is deprecated.',
      'Use `shift_chart()` instead.'
    )
  )
  shift_chart(game)
}

#' Access the real-time game odds for a country by partnered bookmaker
#' 
#' `get_partner_odds()` is deprecated. Use [game_odds()] instead.
#' 
#' @inheritParams game_odds
#' @returns data.frame with one row per game
#' @export

get_partner_odds <- function(country = 'US') {
  .Deprecated(
    new     = 'game_odds()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_partner_odds()` is deprecated.',
      'Use `game_odds()` instead.'
    )
  )
  game_odds(country)
}
