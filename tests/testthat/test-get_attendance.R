test_that('get_attendance() returns non-empty tibble', {
  skip_if_offline()
  test <- get_attendance()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
