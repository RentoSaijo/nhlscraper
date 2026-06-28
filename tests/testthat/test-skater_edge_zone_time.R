# Tests ---------------------------------------------------------

testthat::test_that('skater_edge_zone_time() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- skater_edge_zone_time()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run skater edge zone time tests.
testthat::test_that('skater_edge_zone_time(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- skater_edge_zone_time(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
