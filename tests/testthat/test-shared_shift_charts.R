# Tests ---------------------------------------------------------

# Note: no networked test for the season loaders, consistent with
# shift_charts()/shift_chart_summaries(), as they download large parquet
# snapshots.

testthat::test_that('shared_shift_charts() with <2 players returns message', {
  testthat::expect_message(test <- shared_shift_charts(players = 8478402))
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('shared_shift_charts() with bad minimum_duration returns message', {
  testthat::expect_message(
    test <- shared_shift_charts(
      players = c(8478402, 8477934), minimum_duration = -1
    )
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('.compute_shared_shift_chart() handles season-style multi-game input', {
  shifts <- rbind(
    mk_shift(2024020001, 10, 1, 1, 0, 60),
    mk_shift(2024020001, 10, 2, 1, 30, 90),    # share 30
    mk_shift(2024020002, 10, 1, 1, 0, 60),
    mk_shift(2024020002, 10, 2, 1, 100, 160),  # share 0
    mk_shift(2024020003, 10, 1, 1, 0, 60),
    mk_shift(2024020003, 10, 2, 1, 50, 60)     # share 10
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 1)
  testthat::expect_equal(unique(test$gameId), c(2024020001L, 2024020003L))
  per_game <- tapply(test$duration, test$gameId, sum)
  testthat::expect_equal(as.integer(per_game), c(30L, 10L))
  testthat::expect_equal(names(per_game), c('2024020001', '2024020003'))
  # shiftNumber restarts per game.
  testthat::expect_equal(test$shiftNumber, c(1L, 1L))
})

testthat::test_that('.compute_shared_shift_chart() tracks per-game teams across a trade', {
  # Player 2 plays game 1 for team 10 and game 2 for team 20.
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 60),
    mk_shift(1, 10, 2, 1, 30, 90),
    mk_shift(2, 10, 1, 1, 0, 60),
    mk_shift(2, 20, 2, 1, 30, 90)
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 1)
  testthat::expect_equal(test$teamId2[test$gameId == 1], 10L)
  testthat::expect_equal(test$teamId2[test$gameId == 2], 20L)
})
