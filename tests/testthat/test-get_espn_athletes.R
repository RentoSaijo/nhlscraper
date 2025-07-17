test_that('get_espn_athletes() returns non-empty tibble', {
  skip_if_offline()
  test <- get_espn_athletes()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
