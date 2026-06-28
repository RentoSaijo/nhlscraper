# Tests ---------------------------------------------------------

testthat::test_that('gms() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- gms()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
