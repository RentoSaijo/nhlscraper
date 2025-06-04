test_that('get_teams() returns non-empty tibble', {
  skip_if_offline()
  test <- get_teams()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
