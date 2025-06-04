test_that('get_franchises() returns non-empty tibble', {
  skip_if_offline()
  test <- get_franchises()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
