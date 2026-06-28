# Tests ---------------------------------------------------------

testthat::test_that('player_seasons(8478402) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- player_seasons(8478402)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run player seasons tests.
testthat::test_that('player_seasons(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- player_seasons(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
