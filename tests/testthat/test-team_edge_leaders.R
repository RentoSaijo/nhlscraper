# Tests ---------------------------------------------------------

testthat::test_that('team_edge_leaders() returns non-empty list', {
  testthat::skip_if_offline()
  test <- team_edge_leaders()
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run team edge leaders tests.
testthat::test_that('team_edge_leaders(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- team_edge_leaders(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
