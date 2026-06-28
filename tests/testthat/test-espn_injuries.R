# Tests ---------------------------------------------------------

testthat::test_that('espn_injuries() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- espn_injuries()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
