# Tests ---------------------------------------------------------

testthat::test_that('player_summary(8478402) returns non-empty list', {
  testthat::skip_if_offline()
  test <- player_summary(8478402)
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run player summary tests.
testthat::test_that('player_summary(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- player_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
