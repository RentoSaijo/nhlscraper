# Tests ---------------------------------------------------------

testthat::test_that('playoff_season_stats() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- playoff_season_stats()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
