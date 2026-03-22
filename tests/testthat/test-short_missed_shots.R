test_that(".shot_event_mask() includes short missed shots", {
  play_by_play <- data.frame(
    typeDescKey = c("missed-shot", "shot-on-goal", "blocked-shot"),
    reason = c("short", NA, NA),
    stringsAsFactors = FALSE
  )

  out <- nhlscraper:::.shot_event_mask(
    play_by_play,
    c("missed-shot", "shot-on-goal")
  )

  expect_equal(out, c(TRUE, TRUE, FALSE))
})

test_that(".count_goals_shots() includes short missed shots in Fenwick and Corsi", {
  play_by_play <- data.frame(
    gameId = rep(1L, 4L),
    eventId = 1:4,
    sortOrder = 1:4,
    isHome = c(TRUE, TRUE, TRUE, FALSE),
    typeDescKey = c("missed-shot", "shot-on-goal", "missed-shot", "blocked-shot"),
    reason = c("short", NA, "wide", NA),
    createdRebound = c(FALSE, FALSE, FALSE, FALSE),
    marker = 1:4,
    stringsAsFactors = FALSE
  )

  out <- nhlscraper:::.count_goals_shots(play_by_play)

  expect_equal(out$reason[1], "short")
  expect_equal(out$homeFenwick, c(0L, 1L, 2L, 3L))
  expect_equal(out$homeCorsi, c(0L, 1L, 2L, 3L))
  expect_equal(out$awayCorsi, c(0L, 0L, 0L, 0L))
})

test_that(".flag_is_rebound() treats short missed shots as rebound sources", {
  play_by_play <- data.frame(
    gameId = rep(1L, 2L),
    eventId = 1:2,
    sortOrder = 1:2,
    secondsElapsedInGame = c(10L, 12L),
    typeDescKey = c("missed-shot", "shot-on-goal"),
    reason = c("short", NA),
    situationCode = c("1551", "1551"),
    eventOwnerTeamId = c(10L, 10L),
    isRush = c(NA, FALSE),
    marker = 1:2,
    stringsAsFactors = FALSE
  )

  out <- nhlscraper:::.flag_is_rebound(play_by_play)

  expect_false(out$isRebound[1])
  expect_true(out$createdRebound[1])
  expect_true(out$isRebound[2])
  expect_false(out$createdRebound[2])
})

test_that("calculate_expected_goals() scores short missed shots with xG", {
  local_mocked_bindings(
    .xg_warn_ignored_model = function(model, fn_name) invisible(NULL),
    .xg_prepare_play_by_play = function(play_by_play) play_by_play,
    .xg_build_model_frame = function(shots, play_by_play) {
      shots$shootingPlayerId <- rep(NA_integer_, nrow(shots))
      shots
    },
    .xg_partition_shots = function(shots) rep("sd", nrow(shots)),
    .xg_score_partition = function(df, spec) rep(0.2, nrow(df)),
    .package = "nhlscraper"
  )

  play_by_play <- data.frame(
    gameId = rep(1L, 3L),
    eventId = 1:3,
    sortOrder = 1:3,
    typeDescKey = c("missed-shot", "missed-shot", "shot-on-goal"),
    goaliePlayerIdAgainst = c(NA_integer_, NA_integer_, NA_integer_),
    reason = c("short", "wide", NA),
    stringsAsFactors = FALSE
  )

  out <- calculate_expected_goals(play_by_play)

  expect_true(is.finite(out$xG[1]) && out$xG[1] > 0)
  expect_true(is.finite(out$xG[2]) && out$xG[2] > 0)
  expect_true(is.finite(out$xG[3]) && out$xG[3] > 0)
})
