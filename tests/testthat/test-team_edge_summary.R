# Tests ---------------------------------------------------------

testthat::test_that('team_edge_summary() returns non-empty list', {
  testthat::skip_if_offline()
  test <- team_edge_summary()
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run team edge summary tests.
testthat::test_that('team_edge_summary(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- team_edge_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
