test_that('get_team_roster_statistics() returns non-empty tibble', {
  skip_if_offline()
  test <- get_team_roster_statistics()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_team_roster_statistics(season=19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_team_roster_statistics(season=19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
