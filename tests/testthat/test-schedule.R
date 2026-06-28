# Tests ---------------------------------------------------------

testthat::test_that('schedule(\'2025-01-01\') returns data.frame', {
  testthat::skip_if_offline()
  test <- schedule('2025-01-01')
  testthat::expect_true(is.data.frame(test))
})

# Run schedule tests.
testthat::test_that('schedule(20250101) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- schedule(20250101),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
