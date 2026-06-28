# Tests ---------------------------------------------------------

testthat::test_that('awards() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- awards()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
