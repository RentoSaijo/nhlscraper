# Tests ---------------------------------------------------------

testthat::test_that('game_rosters() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- game_rosters()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run game rosters tests.
testthat::test_that('game_rosters(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- game_rosters(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
