test_that('get_franchise_team_totals() returns non-empty tibble', {
  skip_if_offline()
  test <- get_franchise_team_totals()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
