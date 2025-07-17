test_that('get_venues() returns non-empty tibble', {
  skip_if_offline()
  test <- get_venues()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
