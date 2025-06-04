test_that('get_season_now() returns non-empty tibble', {
  skip_if_offline()
  test <- get_season_now()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
