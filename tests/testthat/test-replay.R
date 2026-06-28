# Tests ---------------------------------------------------------

testthat::test_that('replay() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- replay()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run replay tests.
testthat::test_that('replay(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- replay(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
