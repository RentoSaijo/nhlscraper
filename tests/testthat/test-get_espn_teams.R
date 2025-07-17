test_that('get_espn_teams() returns non-empty tibble', {
  skip_if_offline()
  test <- get_espn_teams()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_espn_teams(1901) returns empty tibble', {
  skip_if_offline()
  test <- get_espn_teams(1901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
