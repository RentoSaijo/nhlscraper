# Tests ---------------------------------------------------------

testthat::test_that('team_week_schedule(1, \'2025-01-01\') returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- team_week_schedule(1, '2025-01-01')
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run team week schedule tests.
testthat::test_that('team_week_schedule(1, 0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- team_week_schedule(1, 0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
