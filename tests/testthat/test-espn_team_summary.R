# Tests ---------------------------------------------------------

testthat::test_that('espn_team_summary() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- espn_team_summary()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run espn team summary tests.
testthat::test_that('espn_team_summary(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- espn_team_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
