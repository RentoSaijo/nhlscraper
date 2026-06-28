# Tests ---------------------------------------------------------

testthat::test_that('attendance() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- attendance()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
