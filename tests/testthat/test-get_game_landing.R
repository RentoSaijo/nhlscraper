test_that('get_game_landing() returns non-empty list', {
  skip_if_offline()
  test <- get_game_landing()
  expect_true(is.list(test) && length(test)>0)
})

test_that('get_game_landing(0) returns empty list', {
  skip_if_offline()
  test <- get_game_landing(0)
  expect_true(is.list(test) && length(test)==0)
})
