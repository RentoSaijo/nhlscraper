# Tests ---------------------------------------------------------

testthat::test_that('wsc_summary() returns non-empty list', {
  testthat::skip_if_offline()
  test <- wsc_summary()
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run wsc summary tests.
testthat::test_that('wsc_summary(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- wsc_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
