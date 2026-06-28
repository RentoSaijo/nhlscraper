# Tests ---------------------------------------------------------

testthat::test_that('roster_statistics(1, 20242025, 3) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- roster_statistics(1, 20242025, 3)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run roster statistics tests.
testthat::test_that('roster_statistics(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- roster_statistics(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
