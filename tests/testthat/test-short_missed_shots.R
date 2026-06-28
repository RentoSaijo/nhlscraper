# Tests ---------------------------------------------------------

testthat::test_that('.shot_event_mask() includes short missed shots', {
  play_by_play <- data.frame(
    eventTypeDescKey = c('missed-shot', 'shot-on-goal', 'blocked-shot'),
    reason = c('short', NA, NA),
    stringsAsFactors = FALSE
  )
  out <- nhlscraper:::.shot_event_mask(
    play_by_play,
    c('missed-shot', 'shot-on-goal')
  )
  testthat::expect_equal(out, c(TRUE, TRUE, FALSE))
})

# Run short missed shots tests.
testthat::test_that('.count_goals_shots() includes short missed shots in Fenwick and Corsi', {
  play_by_play <- data.frame(
    gameId = rep(1L, 4L),
    eventId = 1:4,
    sortOrder = 1:4,
    isHome = c(TRUE, TRUE, TRUE, FALSE),
    eventTypeDescKey = c('missed-shot', 'shot-on-goal', 'missed-shot', 'blocked-shot'),
    reason = c('short', NA, 'wide', NA),
    createdRebound = c(FALSE, FALSE, FALSE, FALSE),
    marker = 1:4,
    stringsAsFactors = FALSE
  )
  out <- nhlscraper:::.count_goals_shots(play_by_play)
  testthat::expect_equal(out$reason[1], 'short')
  testthat::expect_equal(out$homeFenwick, c(0L, 1L, 2L, 3L))
  testthat::expect_equal(out$homeCorsi, c(0L, 1L, 2L, 3L))
  testthat::expect_equal(out$awayCorsi, c(0L, 0L, 0L, 0L))
})

# Run short missed shots tests.
testthat::test_that('.flag_is_rebound() treats short missed shots as rebound sources', {
  play_by_play <- data.frame(
    gameId = rep(1L, 2L),
    eventId = 1:2,
    sortOrder = 1:2,
    secondsElapsedInGame = c(10L, 12L),
    eventTypeDescKey = c('missed-shot', 'shot-on-goal'),
    reason = c('short', NA),
    situationCode = c('1551', '1551'),
    eventOwnerTeamId = c(10L, 10L),
    isRush = c(NA, FALSE),
    marker = 1:2,
    stringsAsFactors = FALSE
  )
  out <- nhlscraper:::.flag_is_rebound(play_by_play)
  testthat::expect_false(out$isRebound[1])
  testthat::expect_true(out$createdRebound[1])
  testthat::expect_true(out$isRebound[2])
  testthat::expect_false(out$createdRebound[2])
})

# Run short missed shots tests.
testthat::test_that('calculate_expected_goals() scores short missed shots with xG', {
  testthat::local_mocked_bindings(
    .xg_warn_ignored_model = function(model, fn_name) invisible(NULL),
    .xg_prepare_play_by_play = function(play_by_play) play_by_play,
    .xg_build_model_frame = function(shots, play_by_play) {
      shots$shootingPlayerId <- rep(NA_integer_, nrow(shots))
      shots
    },
    .xg_partition_shots = function(shots) rep('sd', nrow(shots)),
    .xg_load_bundle = function() list(partition_specs = 'sd'),
    .xg_select_target_season = function(game_id, bundle) {
      rep(20262027L, length(game_id))
    },
    .xg_score_xgboost = function(df, model_key, bundle) rep(0.2, nrow(df)),
    .package = 'nhlscraper'
  )
  play_by_play <- data.frame(
    gameId = rep(1L, 3L),
    eventId = 1:3,
    sortOrder = 1:3,
    eventTypeDescKey = c('missed-shot', 'missed-shot', 'shot-on-goal'),
    goaliePlayerIdAgainst = c(NA_integer_, NA_integer_, NA_integer_),
    reason = c('short', 'wide', NA),
    stringsAsFactors = FALSE
  )
  out <- calculate_expected_goals(play_by_play)
  testthat::expect_true(is.finite(out$xG[1]) && out$xG[1] > 0)
  testthat::expect_true(is.finite(out$xG[2]) && out$xG[2] > 0)
  testthat::expect_true(is.finite(out$xG[3]) && out$xG[3] > 0)
})
