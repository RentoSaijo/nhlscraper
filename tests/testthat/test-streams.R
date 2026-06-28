# Tests ---------------------------------------------------------

testthat::test_that('streams() returns data.frame', {
  testthat::skip_if_offline()
  test <- streams()
  testthat::expect_true(is.data.frame(test))
})
