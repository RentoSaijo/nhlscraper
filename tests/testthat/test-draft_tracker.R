# Tests ---------------------------------------------------------

testthat::test_that('draft_tracker() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- draft_tracker()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
