# Tests ---------------------------------------------------------

testthat::test_that('countries() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- countries()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
