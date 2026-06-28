# Tests ---------------------------------------------------------

testthat::test_that('series() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- series()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
