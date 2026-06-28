# Tests ---------------------------------------------------------

testthat::test_that('standings(\'2025-01-01\') returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- standings('2025-01-01')
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run standings tests.
testthat::test_that('standings(20250101) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- standings(20250101),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
