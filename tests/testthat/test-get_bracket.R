test_that('get_bracket() returns non-empty tibble', {
  skip_if_offline()
  test <- get_bracket()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_bracket(19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_bracket(19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
