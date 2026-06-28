# Tests ---------------------------------------------------------

testthat::test_that('espn_games() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- espn_games()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run espn games tests.
testthat::test_that('espn_games(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- espn_games(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
