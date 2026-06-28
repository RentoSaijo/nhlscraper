# Tests ---------------------------------------------------------

testthat::test_that('franchise_team_stats() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- franchise_team_stats()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
