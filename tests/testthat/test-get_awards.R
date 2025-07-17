test_that('get_awards() returns non-empty tibble', {
  skip_if_offline()
  test <- get_awards()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
