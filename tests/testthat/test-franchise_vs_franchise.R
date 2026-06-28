# Tests ---------------------------------------------------------

testthat::test_that('franchise_vs_franchise() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- franchise_vs_franchise()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
