# Tests ---------------------------------------------------------

testthat::test_that('award_winners() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- award_winners()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
