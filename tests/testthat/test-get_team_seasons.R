test_that('get_team_seasons() returns non-empty tibble', {
  skip_if_offline()
  test <- get_team_seasons()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_team_seasons(\'Boston Bruins\') returns empty tibble', {
  skip_if_offline()
  test <- get_team_seasons('Boston')
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
