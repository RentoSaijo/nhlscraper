test_that("player_game_log(8478402, 2, 20242025) returns non-empty data.frame", {
  skip_if_offline()
  test <- player_game_log(8478402, 2, 20242025)
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("player_game_log(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- player_game_log(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

