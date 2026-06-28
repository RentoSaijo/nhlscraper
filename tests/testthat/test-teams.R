# Tests ---------------------------------------------------------

testthat::test_that('teams() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- teams()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
