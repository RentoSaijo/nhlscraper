# Tests ---------------------------------------------------------

testthat::test_that('officials() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- officials()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
