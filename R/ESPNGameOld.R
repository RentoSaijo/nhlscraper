#' Access the ESPN summary for an event (game)
#' 
#' `get_espn_event()` is deprecated. Use [espn_game_summary()] instead.
#' 
#' @param event integer ID (e.g., 401777460); see [espn_games()] for 
#' reference
#' @return data.frame with one row per event (game)
#' @export

get_espn_event <- function(event = 401777460) {
  .Deprecated(
    new     = 'espn_game_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event()` is dprecated.',
      'Use `espn_game_summary()` instead.'
    )
  )
  espn_game_summary(event)
}

#' Access the ESPN play-by-play for an event (game)
#' 
#' `get_espn_event_play_by_play()` is deprecated. Use [espn_play_by_play()] 
#' instead.
#' 
#' @inheritParams get_espn_event
#' @returns data.frame with one row per play
#' @export

get_espn_event_play_by_play <- function(event = 401777460) {
  .Deprecated(
    new     = 'espn_play_by_play()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event_play_by_play()` is deprecated.',
      'Use `espn_play_by_play()` instead.'
    )
  )
  espn_play_by_play(event)
}

#' Access the ESPN odds for an event (game)
#' 
#' `get_espn_event_odds()` is deprecated. Use [espn_game_odds()] 
#' instead.
#' 
#' @inheritParams get_espn_event
#' @returns data.frame with one row per provider
#' @export

get_espn_event_odds <- function(event = 401777460) {
  .Deprecated(
    new     = 'espn_game_odds()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event_odds()` is deprecated.',
      'Use `espn_game_odds()` instead.'
    )
  )
  espn_game_odds(event)
}

#' Access the ESPN events (games) by start and end dates
#' 
#' `get_espn_events()` is defunct. Use [espn_games()] instead.
#' 
#' @export

get_espn_events <- function() {
  .Defunct(
    new     = 'espn_games()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_events()` is defunct.',
      'Use `espn_games()` instead.'
    )
  )
}

#' Access the three stars for an ESPN event (game)
#' 
#' `get_espn_event_stars()` is defunct. Use [gc_summary()] and/or 
#' [wsc_summary()] instead.
#' 
#' @export

get_espn_event_stars <- function() {
  .Defunct(
    new     = 'gc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event_stars()` is defunct.',
      'Use `gc_summary()` and/or `wsc_summary()` instead.'
    )
  )
}

#' Access the officials for an ESPN event (game)
#' 
#' `get_espn_event_officials()` is defunct. Use [gc_summary()] and/or 
#' [wsc_summary()] instead.
#' 
#' @export

get_espn_event_officials <- function() {
  .Defunct(
    new     = 'gc_summary()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_event_officials()` is defunct.',
      'Use `gc_summary()` and/or `wsc_summary()` instead.'
    )
  )
}
