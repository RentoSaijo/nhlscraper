# Tests ---------------------------------------------------------

testthat::test_that('franchise_playoff_situational_results() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- franchise_playoff_situational_results()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
