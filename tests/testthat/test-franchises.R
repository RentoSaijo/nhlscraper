# Tests ---------------------------------------------------------

testthat::test_that('franchises() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- franchises()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
