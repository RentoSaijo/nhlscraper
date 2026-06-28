# Tests ---------------------------------------------------------

testthat::test_that('series_schedule(20242025) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- series_schedule(20242025)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run series schedule tests.
testthat::test_that('series_schedule(2025) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- series_schedule(2025),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
