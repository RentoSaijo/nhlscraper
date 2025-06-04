test_that('get_player_game_log() returns non-empty tibble', {
  skip_if_offline()
  test <- get_player_game_log()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_player_game_log(season=19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_player_game_log(season=19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
