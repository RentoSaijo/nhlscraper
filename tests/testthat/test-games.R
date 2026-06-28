# Tests ---------------------------------------------------------

testthat::test_that('games() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- games()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
