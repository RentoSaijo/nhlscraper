# Tests ---------------------------------------------------------

testthat::test_that('espn_transactions() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- espn_transactions()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run espn transactions tests.
testthat::test_that('espn_transactions(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- espn_transactions(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
