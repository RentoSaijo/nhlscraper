test_that('get_countries() returns non-empty tibble', {
  skip_if_offline()
  test <- get_countries()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
