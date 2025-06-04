test_that('get_seasons() returns non-empty tibble', {
  skip_if_offline()
  test <- get_seasons()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
