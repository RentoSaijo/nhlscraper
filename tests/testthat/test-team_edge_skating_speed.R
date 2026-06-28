# Tests ---------------------------------------------------------

testthat::test_that('team_edge_skating_speed() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- team_edge_skating_speed()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run team edge skating speed tests.
testthat::test_that('team_edge_skating_speed(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- team_edge_skating_speed(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
