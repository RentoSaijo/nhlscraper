# Tests ---------------------------------------------------------

testthat::test_that('espn_game_summary() returns non-empty list', {
  testthat::skip_if_offline()
  test <- espn_game_summary()
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run espn game summary tests.
testthat::test_that('espn_game_summary(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- espn_game_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
