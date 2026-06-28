# Tests ---------------------------------------------------------

testthat::test_that('pss() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- pss()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
