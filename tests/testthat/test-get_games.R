test_that('get_games() returns non-empty tibble', {
  skip_if_offline()
  test <- get_games()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
