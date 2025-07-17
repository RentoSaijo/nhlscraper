test_that('get_series() returns non-empty tibble', {
  skip_if_offline()
  test <- get_series()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_series(19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_series(19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
