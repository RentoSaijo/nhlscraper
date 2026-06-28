# Tests ---------------------------------------------------------

testthat::test_that('bracket(20242025) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- bracket(20242025)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run bracket tests.
testthat::test_that('bracket(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- bracket(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
