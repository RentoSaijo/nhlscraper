test_that('get_game_boxscore() returns non-empty tibble', {
  skip_if_offline()
  test <- get_game_boxscore()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_game_boxscore(0) returns empty tibble', {
  skip_if_offline()
  test <- get_game_boxscore(0)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
