# Tests ---------------------------------------------------------

testthat::test_that('skater_edge_seasons() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- skater_edge_seasons()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
