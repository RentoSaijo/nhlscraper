# Tests ---------------------------------------------------------

# Note: no networked test, consistent with shift_chart_summaries(), as it
# downloads large parquet snapshots.

testthat::test_that('shared_shift_chart_summaries() with <2 players returns message', {
  testthat::expect_message(
    test <- shared_shift_chart_summaries(players = 8478402)
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('.compute_shared_shift_chart_summary() handles multi-game input', {
  shifts <- rbind(
    mk_shift(2024020001, 10, 1, 1, 0, 60),
    mk_shift(2024020001, 10, 2, 1, 30, 90),   # share 30 in P1
    mk_shift(2024020002, 10, 1, 1, 0, 60),
    mk_shift(2024020002, 10, 2, 1, 100, 160)  # both play, share 0
  )
  summaries <- rbind(
    mk_summary(2024020001, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 1),
    mk_summary(2024020001, 10, 'EDM', 2, 'Leon', 'Draisaitl', 29, 'C', 1),
    mk_summary(2024020002, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 1),
    mk_summary(2024020002, 10, 'EDM', 2, 'Leon', 'Draisaitl', 29, 'C', 1)
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    shifts, summaries, c(1L, 2L), 1
  )
  testthat::expect_equal(nrow(test), 2)
  testthat::expect_equal(test$gameId, c(2024020001L, 2024020002L))
  testthat::expect_equal(test$shifts, c(1L, 0L))
  testthat::expect_equal(test$timeOnIce, c(30L, 0L))
})

testthat::test_that('.compute_shared_shift_chart_summary() reflects per-game team info', {
  # Player 2 changes teams between games; info comes from that game's
  # summaries.
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 60),
    mk_shift(1, 10, 2, 1, 30, 90),
    mk_shift(2, 10, 1, 1, 0, 60),
    mk_shift(2, 20, 2, 1, 30, 90)
  )
  summaries <- rbind(
    mk_summary(1, 10, 'EDM', 1, 'A', 'B', 1, 'C', 1),
    mk_summary(1, 10, 'EDM', 2, 'C', 'D', 2, 'C', 1),
    mk_summary(2, 10, 'EDM', 1, 'A', 'B', 1, 'C', 1),
    mk_summary(2, 20, 'FLA', 2, 'C', 'D', 2, 'C', 1)
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    shifts, summaries, c(1L, 2L), 1
  )
  testthat::expect_equal(test$teamTriCode2[test$gameId == 1], 'EDM')
  testthat::expect_equal(test$teamTriCode2[test$gameId == 2], 'FLA')
})
