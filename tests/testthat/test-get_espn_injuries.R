test_that('get_espn_injuries() returns tibble', {
  skip_if_offline()
  test <- get_espn_injuries()
  expect_true(tibble::is_tibble(test))
})
