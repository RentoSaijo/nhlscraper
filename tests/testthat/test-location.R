# Tests ---------------------------------------------------------

testthat::test_that('location() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- location()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run location tests.
testthat::test_that('location(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- location(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
