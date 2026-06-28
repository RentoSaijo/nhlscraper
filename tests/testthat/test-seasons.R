# Tests ---------------------------------------------------------

testthat::test_that('seasons() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- seasons()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
