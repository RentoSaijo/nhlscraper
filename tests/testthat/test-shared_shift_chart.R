# Tests ---------------------------------------------------------

testthat::test_that('shared_shift_chart() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- shared_shift_chart()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
  testthat::expect_true(
    all(nhlscraper:::.shared_shift_chart_columns(2L) %in% names(test))
  )
})

testthat::test_that('shared_shift_chart(0) returns message and empty data.frame', {
  testthat::expect_message(test <- shared_shift_chart(0))
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('shared_shift_chart() with <2 players returns message', {
  testthat::expect_message(test <- shared_shift_chart(players = 8478402))
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
  testthat::expect_message(
    test <- shared_shift_chart(players = c(8478402, 8478402))
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('.compute_shared_shift_chart() finds a pairwise overlap', {
  shifts <- rbind(
    mk_shift(1, 10, 101, 1, 0, 50),
    mk_shift(1, 20, 102, 1, 30, 80)
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(101L, 102L), 1)
  testthat::expect_equal(nrow(test), 1)
  testthat::expect_equal(
    names(test), nhlscraper:::.shared_shift_chart_columns(2L)
  )
  # Player-grouped column order: teamId1, playerId1, teamId2, playerId2, ...
  col_names <- names(test)
  testthat::expect_true(
    which(col_names == 'teamId1') < which(col_names == 'playerId1')
  )
  testthat::expect_true(
    which(col_names == 'playerId1') < which(col_names == 'teamId2')
  )
  testthat::expect_true(
    which(col_names == 'teamId2') < which(col_names == 'playerId2')
  )
  testthat::expect_equal(test$teamId1, 10L)
  testthat::expect_equal(test$teamId2, 20L)
  testthat::expect_equal(test$playerId1, 101L)
  testthat::expect_equal(test$playerId2, 102L)
  testthat::expect_equal(test$shiftNumber, 1L)
  testthat::expect_equal(test$startSecondsElapsedInGame, 30L)
  testthat::expect_equal(test$endSecondsElapsedInGame, 50L)
  testthat::expect_equal(test$startTime, '00:30')
  testthat::expect_equal(test$endTime, '00:50')
  testthat::expect_equal(test$duration, 20L)
})

testthat::test_that('.compute_shared_shift_chart() applies minimum_duration strictly', {
  # minimum_duration = 1 keeps only overlaps > 1s.
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 31),
    mk_shift(1, 10, 2, 1, 30, 60),   # 1s overlap, dropped at threshold 1
    mk_shift(1, 10, 1, 2, 0, 32),
    mk_shift(1, 10, 2, 2, 30, 60)    # 2s overlap, kept at threshold 1
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 1)
  testthat::expect_equal(nrow(test), 1)
  testthat::expect_equal(test$periodNumber, 2L)
  testthat::expect_equal(test$duration, 2L)
  # A stricter threshold drops the 2s overlap too.
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 5)
  testthat::expect_equal(nrow(test), 0)
  # minimum_duration = 0 (the default) keeps both.
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 0)
  testthat::expect_equal(nrow(test), 2)
})

testthat::test_that('.compute_shared_shift_chart() requires all players on ice', {
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 60),
    mk_shift(1, 10, 2, 1, 20, 90),
    mk_shift(1, 10, 3, 1, 40, 100)
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L, 3L), 1)
  testthat::expect_equal(test$startSecondsElapsedInGame, 40L)
  testthat::expect_equal(test$endSecondsElapsedInGame, 60L)
  testthat::expect_equal(test$duration, 20L)
})

testthat::test_that('.compute_shared_shift_chart() unions duplicated shifts', {
  # Player 1 has overlapping rows [0,40] and [20,60]; union is [0,60], so
  # the overlap with [10,70] is [10,60] once, not double-counted.
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 40),
    mk_shift(1, 10, 1, 1, 20, 60),
    mk_shift(1, 10, 2, 1, 10, 70)
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 1)
  testthat::expect_equal(nrow(test), 1)
  testthat::expect_equal(test$duration, 50L)
})

testthat::test_that('.compute_shared_shift_chart() attributes periods and reconstructs times in overtime', {
  # Regular-season overtime: period 4 starts at game second 3600.
  ot_1 <- mk_shift(1, 10, 1, 4, 10, 100)
  ot_1$startSecondsElapsedInGame <- 3610L
  ot_1$endSecondsElapsedInGame   <- 3700L
  ot_2 <- mk_shift(1, 20, 2, 4, 50, 150)
  ot_2$startSecondsElapsedInGame <- 3650L
  ot_2$endSecondsElapsedInGame   <- 3750L
  test <- nhlscraper:::.compute_shared_shift_chart(
    rbind(ot_1, ot_2), c(1L, 2L), 1
  )
  testthat::expect_equal(test$periodNumber, 4L)
  testthat::expect_equal(test$duration, 50L)
  testthat::expect_equal(test$startSecondsElapsedInPeriod, 50L)
  testthat::expect_equal(test$endSecondsElapsedInPeriod, 100L)
  testthat::expect_equal(test$startTime, '00:50')
  testthat::expect_equal(test$endTime, '01:40')
})

testthat::test_that('.compute_shared_shift_chart() skips games missing a player', {
  shifts <- rbind(
    mk_shift(1, 10, 1, 1, 0, 60),
    mk_shift(1, 10, 2, 1, 30, 90),
    mk_shift(2, 10, 1, 1, 0, 60)
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 1)
  testthat::expect_equal(unique(test$gameId), 1L)
})

testthat::test_that('.compute_shared_shift_chart() agrees with brute force', {
  set.seed(42)
  brute_force <- function(shifts, players) {
    span   <- max(shifts$endSecondsElapsedInGame)
    on_ice <- sapply(players, function(p) {
      seconds <- rep(FALSE, span)
      rows    <- shifts[shifts$playerId == p, , drop = FALSE]
      for (r in seq_len(nrow(rows))) {
        seconds[
          (rows$startSecondsElapsedInGame[r] + 1):
            rows$endSecondsElapsedInGame[r]
        ] <- TRUE
      }
      seconds
    })
    sum(rowSums(on_ice) == length(players))
  }
  random_shifts <- function(player_id, n = 25) {
    do.call(rbind, lapply(seq_len(n), function(k) {
      period <- sample(1:3, 1)
      start  <- sample(0:1150, 1)
      mk_shift(
        1, 10, player_id, period, start, min(start + sample(20:60, 1), 1200)
      )
    }))
  }
  shifts <- rbind(random_shifts(1), random_shifts(2), random_shifts(3))
  test   <- nhlscraper:::.compute_shared_shift_chart(
    shifts, c(1L, 2L, 3L), 0
  )
  testthat::expect_equal(
    sum(test$duration), brute_force(shifts, c(1L, 2L, 3L))
  )
})

testthat::test_that('.shared_game_type() and .shared_excluded_periods() decode game IDs', {
  testthat::expect_equal(nhlscraper:::.shared_game_type(2024020042L), 2L)
  testthat::expect_equal(nhlscraper:::.shared_game_type(2023030417L), 3L)
  testthat::expect_equal(nhlscraper:::.shared_excluded_periods(2024020042L), 5L)
  testthat::expect_null(nhlscraper:::.shared_excluded_periods(2023030417L))
})

testthat::test_that('.compute_shared_shift_chart() excludes the shootout for regular-season games', {
  # Regular-season game (type 02): both players have overlapping period-5
  # (shootout) rows, which are NOT shared ice time and must be dropped.
  so_1 <- mk_shift(2024020042, 10, 1, 5, 0, 30)
  so_1$startSecondsElapsedInGame <- 3900L
  so_1$endSecondsElapsedInGame   <- 3930L
  so_2 <- mk_shift(2024020042, 10, 2, 5, 0, 30)
  so_2$startSecondsElapsedInGame <- 3900L
  so_2$endSecondsElapsedInGame   <- 3930L
  shifts <- rbind(
    mk_shift(2024020042, 10, 1, 1, 0, 60),
    mk_shift(2024020042, 10, 2, 1, 30, 90),
    so_1,
    so_2
  )
  test <- nhlscraper:::.compute_shared_shift_chart(shifts, c(1L, 2L), 0)
  testthat::expect_false(any(test$periodNumber == 5L))
  testthat::expect_equal(sum(test$duration), 30L)
})

testthat::test_that('.compute_shared_shift_chart() keeps period 5 for playoff games', {
  # Playoff game (type 03): period 5 is the second overtime, real ice time.
  ot_1 <- mk_shift(2023030417, 10, 1, 5, 10, 80)
  ot_1$startSecondsElapsedInGame <- 4810L
  ot_1$endSecondsElapsedInGame   <- 4880L
  ot_2 <- mk_shift(2023030417, 10, 2, 5, 30, 90)
  ot_2$startSecondsElapsedInGame <- 4830L
  ot_2$endSecondsElapsedInGame   <- 4890L
  test <- nhlscraper:::.compute_shared_shift_chart(
    rbind(ot_1, ot_2), c(1L, 2L), 0
  )
  testthat::expect_true(any(test$periodNumber == 5L))
  testthat::expect_equal(test$duration, 50L)
  testthat::expect_equal(test$startSecondsElapsedInPeriod, 30L)
  testthat::expect_equal(test$endSecondsElapsedInPeriod, 80L)
})

testthat::test_that('shared_shift_chart() messages when a player has no shifts', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- shared_shift_chart(players = c(8478402, 999999999)),
    '999999999'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('shared_shift_chart() messages when no shift data is returned', {
  testthat::skip_if_not_installed('testthat', '3.2.0')
  testthat::local_mocked_bindings(
    shift_chart = function(...) data.frame(),
    .package = 'nhlscraper'
  )
  testthat::expect_message(test <- shared_shift_chart(), 'No shift data')
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

testthat::test_that('shared_shift_chart() messages when players share no intervals', {
  testthat::skip_if_not_installed('testthat', '3.2.0')
  testthat::local_mocked_bindings(
    shift_chart = function(...) rbind(
      mk_shift(2023030417, 10, 8478402, 1, 0, 30),
      mk_shift(2023030417, 20, 8477934, 1, 50, 90)
    ),
    .package = 'nhlscraper'
  )
  testthat::expect_message(
    test <- shared_shift_chart(),
    'shared no on-ice intervals'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
  # Typed empty chart, not a bare data.frame.
  testthat::expect_true(
    all(nhlscraper:::.shared_shift_chart_columns(2L) %in% names(test))
  )
})

testthat::test_that('.shared_excluded_periods() covers the Return-to-Play round-robin games', {
  # 2019030002 and 2019030016 carry playoff game IDs but used regular-season
  # overtime/shootout rules; period 5 (shootout) must be excluded for them.
  testthat::expect_equal(nhlscraper:::.shared_excluded_periods(2019030002L), 5L)
  testthat::expect_equal(nhlscraper:::.shared_excluded_periods(2019030016L), 5L)
  # A normal playoff game from the same season keeps period 5 (2nd OT).
  testthat::expect_null(nhlscraper:::.shared_excluded_periods(2019030411L))
})
