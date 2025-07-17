test_that('get_players() returns non-empty tibble', {
  skip_if_offline()
  test <- get_players()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
