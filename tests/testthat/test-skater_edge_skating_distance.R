# Tests ---------------------------------------------------------

testthat::test_that('skater_edge_skating_distance() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- skater_edge_skating_distance()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run skater edge skating distance tests.
testthat::test_that('skater_edge_skating_distance(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- skater_edge_skating_distance(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
