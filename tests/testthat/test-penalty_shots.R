# Tests ---------------------------------------------------------

testthat::test_that('penalty_shots() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- penalty_shots()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
