# Tests ---------------------------------------------------------

testthat::test_that('team_seasons(1) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- team_seasons(1)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run team seasons tests.
testthat::test_that('team_seasons(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- team_seasons(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
