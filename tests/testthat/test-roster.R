# Tests ---------------------------------------------------------

testthat::test_that('roster(1, 20242025, \'forwards\') returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- roster(1, 20242025, 'forwards')
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run roster tests.
testthat::test_that('roster(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- roster(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
