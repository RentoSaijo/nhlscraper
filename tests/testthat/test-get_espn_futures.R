test_that('get_espn_futures() returns tibble', {
  skip_if_offline()
  test <- get_espn_futures()
  expect_true(tibble::is_tibble(test))
})

test_that('get_espn_futures(1901) returns empty tibble', {
  skip_if_offline()
  test <- get_espn_futures(1901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
