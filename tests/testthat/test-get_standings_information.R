test_that('get_standings_information() returns non-empty tibble', {
  skip_if_offline()
  test <- get_standings_information()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
