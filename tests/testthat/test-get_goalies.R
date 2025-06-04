test_that('get_goalies() returns non-empty tibble', {
  skip_if_offline()
  test <- get_goalies()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_goalies(18001801, 19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_goalies(18001801, 19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
