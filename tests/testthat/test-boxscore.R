# Tests ---------------------------------------------------------

testthat::test_that('boxscore() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- boxscore()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run boxscore tests.
testthat::test_that('boxscore(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- boxscore(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
