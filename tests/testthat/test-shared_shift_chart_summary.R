# Tests ---------------------------------------------------------

testthat::test_that('shared_shift_chart_summary() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- shared_shift_chart_summary()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
  testthat::expect_true(
    all(c('gameId', 'playerId1', 'playerId2', 'teamTriCode1',
          'periodNumber', 'shifts', 'timeOnIce') %in% names(test))
  )
})

testthat::test_that('shared_shift_chart_summary(0) returns message and empty data.frame', {
  testthat::expect_message(test <- shared_shift_chart_summary(0))
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('.compute_shared_shift_chart_summary() aggregates per period with zero-fill', {
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 50),    # P1: shares [40,50] with player 2
    mk_shift(1, 10, 2, 1, 40, 120),
    mk_shift(1, 10, 1, 2, 100, 200), # P2: shares [150,200]
    mk_shift(1, 10, 2, 2, 150, 260),
    mk_shift(1, 10, 1, 3, 0, 60),    # P3: both play, no overlap
    mk_shift(1, 10, 2, 3, 70, 130)
  )
  summaries <- rbind(
    mk_summary(1, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 1:3),
    mk_summary(1, 10, 'EDM', 2, 'Leon', 'Draisaitl', 29, 'C', 1:3)
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    shifts, summaries, c(1L, 2L), 1
  )
  testthat::expect_equal(nrow(test), 3)
  testthat::expect_equal(test$periodNumber, 1:3)
  testthat::expect_equal(test$shifts, c(1L, 1L, 0L))
  testthat::expect_equal(test$timeOnIce, c(10L, 50L, 0L))
  testthat::expect_equal(unique(test$playerFirstName1), 'Connor')
  testthat::expect_equal(unique(test$playerLastName2), 'Draisaitl')
  # All player 1 info precedes all player 2 info, which precedes shared cols.
  col_names <- names(test)
  testthat::expect_true(
    which(col_names == 'positionCode1') < which(col_names == 'teamId2')
  )
  testthat::expect_true(
    which(col_names == 'positionCode2') < which(col_names == 'periodNumber')
  )
  testthat::expect_equal(unique(test$sweaterNumber1), 97L)
  testthat::expect_equal(unique(test$teamTriCode2), 'EDM')
  testthat::expect_equal(unique(test$positionCode1), 'C')
})

testthat::test_that('.compute_shared_shift_chart_summary() keeps only periods all players skated', {
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 60),
    mk_shift(1, 10, 2, 1, 30, 90)
  )
  summaries <- rbind(
    mk_summary(1, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 1:3),
    mk_summary(1, 10, 'EDM', 2, 'Leon', 'Draisaitl', 29, 'C', 1:2)
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    shifts, summaries, c(1L, 2L), 1
  )
  # Player 2 has no period-3 ice time, so no period-3 row.
  testthat::expect_equal(test$periodNumber, 1:2)
  testthat::expect_equal(test$timeOnIce, c(30L, 0L))
})

testthat::test_that('.compute_shared_shift_chart_summary() skips games missing a player', {
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 60),
    mk_shift(1, 10, 2, 1, 30, 90),
    mk_shift(2, 10, 1, 1, 0, 60)
  )
  summaries <- rbind(
    mk_summary(1, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 1),
    mk_summary(1, 10, 'EDM', 2, 'Leon', 'Draisaitl', 29, 'C', 1),
    mk_summary(2, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 1)
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    shifts, summaries, c(1L, 2L), 1
  )
  testthat::expect_equal(unique(test$gameId), 1L)
})

testthat::test_that('.compute_shared_shift_chart_summary() excludes the shootout period from summaries', {
  # Regular-season game: summaries include a period-5 row for both players
  # (from the HTML report); it must not appear in the shared summary.
  shifts <- rbind(
    mk_shift(2024020042, 10, 1, 1, 0, 60),
    mk_shift(2024020042, 10, 2, 1, 30, 90)
  )
  summaries <- rbind(
    mk_summary(2024020042, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C',
               c(1L, 5L)),
    mk_summary(2024020042, 10, 'EDM', 2, 'Leon', 'Draisaitl', 29, 'C',
               c(1L, 5L))
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    shifts, summaries, c(1L, 2L), 0
  )
  testthat::expect_false(any(test$periodNumber == 5L))
  testthat::expect_equal(test$periodNumber, 1L)
  testthat::expect_equal(test$timeOnIce, 30L)
})

testthat::test_that('.compute_shared_shift_chart_summary() keeps period 5 for playoff games', {
  ot_1 <- mk_shift(2023030417, 10, 1, 5, 10, 80)
  ot_1$startSecondsElapsedInGame <- 4810L
  ot_1$endSecondsElapsedInGame   <- 4880L
  ot_2 <- mk_shift(2023030417, 10, 2, 5, 30, 90)
  ot_2$startSecondsElapsedInGame <- 4830L
  ot_2$endSecondsElapsedInGame   <- 4890L
  summaries <- rbind(
    mk_summary(2023030417, 10, 'EDM', 1, 'Connor', 'McDavid', 97, 'C', 5L),
    mk_summary(2023030417, 10, 'FLA', 2, 'Aleksander', 'Barkov', 16, 'C', 5L)
  )
  test <- nhlscraper:::.compute_shared_shift_chart_summary(
    rbind(ot_1, ot_2), summaries, c(1L, 2L), 0
  )
  testthat::expect_equal(test$periodNumber, 5L)
  testthat::expect_equal(test$timeOnIce, 50L)
})
