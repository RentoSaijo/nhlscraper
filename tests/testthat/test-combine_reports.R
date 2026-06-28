# Tests ---------------------------------------------------------

testthat::test_that('combine_reports() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- combine_reports()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
