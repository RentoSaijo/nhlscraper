test_that('get_streams() returns non-empty tibble', {
  skip_if_offline()
  test <- get_streams()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
