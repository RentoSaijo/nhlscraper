test_that('get_team_scoreboard(\'Boston\') returns empty tibble', {
  skip_if_offline()
  test <- get_team_scoreboard('Boston')
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
