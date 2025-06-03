test_that('get_shift_charts() returns non-empty tibble', {
  skip_if_offline()
  test <- get_shift_charts()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_shift_charts(0) returns empty tibble', {
  skip_if_offline()
  test <- get_shift_charts(0)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})

