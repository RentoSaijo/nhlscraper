# Tests ---------------------------------------------------------

testthat::test_that('team_season_statistics() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- team_season_statistics()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
