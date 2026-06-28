# Tests ---------------------------------------------------------

testthat::test_that('roster_stats(1, 20242025, 3) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- roster_stats(1, 20242025, 3)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
