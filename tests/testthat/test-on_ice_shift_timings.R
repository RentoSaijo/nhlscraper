test_that("native on-ice shift timing matches R implementation", {
  skip_if_not(.ensure_local_native_symbol("nhlscraper_on_ice_shift_timings"))

  play_by_play <- data.frame(
    gameId = rep(1L, 3L),
    periodNumber = rep(1L, 3L),
    secondsElapsedInPeriod = c(100L, 350L, 700L),
    homeGoaliePlayerId = rep(100L, 3L),
    awayGoaliePlayerId = rep(200L, 3L),
    homeSkater1PlayerId = c(101L, 101L, 101L),
    homeSkater2PlayerId = c(102L, 102L, 102L),
    homeSkater3PlayerId = c(103L, 103L, NA_integer_),
    homeSkater4PlayerId = c(104L, NA_integer_, 104L),
    homeSkater5PlayerId = c(105L, 105L, 105L),
    awaySkater1PlayerId = c(201L, 201L, 201L),
    awaySkater2PlayerId = c(202L, 202L, 202L),
    awaySkater3PlayerId = c(203L, 203L, 203L),
    awaySkater4PlayerId = c(204L, 204L, 204L),
    awaySkater5PlayerId = c(205L, 205L, 205L)
  )
  shift_data <- data.frame(
    gameId = rep(1L, 10L),
    periodNumber = rep(1L, 10L),
    playerId = c(101L, 100L, 101L, 102L, 201L, 200L, 202L, 105L, 205L, 104L),
    startSecondsElapsedInPeriod = c(0L, 0L, 300L, 50L, 0L, 0L, 400L, 600L, 650L, 650L),
    endSecondsElapsedInPeriod = c(200L, 1200L, 500L, 150L, 1000L, 1200L, 800L, 800L, 900L, 900L)
  )

  expected <- .compute_on_ice_shift_timing_in_r(
    play_by_play,
    .sort_shift_chart_for_timing(shift_data)
  )
  actual <- .compute_on_ice_shift_timing_matrices(play_by_play, shift_data)

  expect_equal(actual, expected)
})
