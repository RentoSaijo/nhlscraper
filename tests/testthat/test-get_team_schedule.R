test_that('get_team_schedule() returns non-empty tibble', {
  skip_if_offline()
  test <- get_team_schedule()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_team_schedule(season=19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_team_schedule(season=19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
