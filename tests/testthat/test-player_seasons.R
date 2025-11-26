test_that('player_seasons() returns non-empty data.frame', {
  skip_if_offline()
  test <- player_seasons()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('player_seasons(0) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- player_seasons(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
