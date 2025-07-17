test_that('get_franchise_season_by_season() returns non-empty tibble', {
  skip_if_offline()
  test <- get_franchise_season_by_season()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
