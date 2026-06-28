# Tests ---------------------------------------------------------

testthat::test_that('wsc_pbp() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- wsc_pbp()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
