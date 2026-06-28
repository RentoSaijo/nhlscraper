# Tests ---------------------------------------------------------

testthat::test_that('venues() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- venues()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
