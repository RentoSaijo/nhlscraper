# Tests ---------------------------------------------------------

testthat::test_that('players() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- players()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
