# Tests ---------------------------------------------------------

testthat::test_that('skater_regular_statistics() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- skater_regular_statistics()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
