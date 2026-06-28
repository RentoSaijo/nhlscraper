# Tests ---------------------------------------------------------

testthat::test_that('team_prospects() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- team_prospects()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run team prospects tests.
testthat::test_that('team_prospects(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- team_prospects(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
