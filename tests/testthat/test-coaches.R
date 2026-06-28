# Tests ---------------------------------------------------------

testthat::test_that('coaches() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- coaches()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
