# Tests ---------------------------------------------------------

testthat::test_that('skater_playoff_stats() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- skater_playoff_stats()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
