# Tests ---------------------------------------------------------

testthat::test_that('tv_schedule(\'2025-01-01\') returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- tv_schedule('2025-01-01')
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run tv schedule tests.
testthat::test_that('tv_schedule(20250101) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- tv_schedule(20250101),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
