test_that('get_team_prospects() returns non-empty tibble', {
  skip_if_offline()
  test <- get_team_prospects()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_team_prospects(\'Boston\') returns empty tibble', {
  skip_if_offline()
  test <- get_team_prospects('Boston')
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
