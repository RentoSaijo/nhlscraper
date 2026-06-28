# Tests ---------------------------------------------------------

testthat::test_that('player_game_log(8478402, 20242025, 2) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- player_game_log(8478402, 20242025, 2)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run player game log tests.
testthat::test_that('player_game_log(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- player_game_log(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
