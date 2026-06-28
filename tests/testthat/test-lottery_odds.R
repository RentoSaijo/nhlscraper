# Tests ---------------------------------------------------------

testthat::test_that('lottery_odds() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- lottery_odds()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
