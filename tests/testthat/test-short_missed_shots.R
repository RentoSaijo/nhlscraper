test_that(".count_goals_shots() excludes short missed shots from Fenwick and Corsi", {
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

  out <- .count_goals_shots(play_by_play)

  expect_equal(out$reason[1], "short")
  expect_equal(out$homeFenwick, c(0L, 0L, 1L, 2L))
  expect_equal(out$homeCorsi, c(0L, 0L, 1L, 2L))
  expect_equal(out$awayCorsi, c(0L, 0L, 0L, 0L))
})

test_that(".flag_is_rebound() ignores short missed shots as rebound sources", {
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

  out <- .flag_is_rebound(play_by_play)

  expect_true(is.na(out$isRebound[1]))
  expect_true(is.na(out$createdRebound[1]))
  expect_false(out$isRebound[2])
  expect_false(out$createdRebound[2])
})

test_that("calculate_expected_goals() leaves short missed shots without xG", {
  local_mocked_bindings(
    add_deltas = function(play_by_play) play_by_play,
    add_shooter_biometrics = function(play_by_play) {
      play_by_play$shooterPositionCode <- rep(NA_character_, nrow(play_by_play))
      play_by_play
    },
    add_goalie_biometrics = function(play_by_play) play_by_play,
    .package = "nhlscraper"
  )

  play_by_play <- data.frame(
    gameId = rep(1L, 3L),
    eventId = 1:3,
    sortOrder = 1:3,
    typeDescKey = c("missed-shot", "missed-shot", "shot-on-goal"),
    reason = c("short", "wide", NA),
    situationCode = c("1551", "1551", "1551"),
    isEmptyNetAgainst = c(FALSE, FALSE, FALSE),
    distance = c(20, 20, 20),
    angle = c(10, 10, 10),
    shotType = c("wrist", "wrist", "wrist"),
    stringsAsFactors = FALSE
  )

  out <- calculate_expected_goals(play_by_play, model = 1)

  expect_true(is.na(out$xG[1]))
  expect_true(is.finite(out$xG[2]) && out$xG[2] > 0)
  expect_true(is.finite(out$xG[3]) && out$xG[3] > 0)
})
