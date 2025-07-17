test_that('get_officials() returns non-empty tibble', {
  skip_if_offline()
  test <- get_officials()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
