test_that('get_playoff_bracket(2025) returns non-empty tibble', {
  skip_if_offline()
  test <- get_playoff_bracket(2025)
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_playoff_bracket(1900) returns empty tibble', {
  skip_if_offline()
  test <- get_playoff_bracket(1900)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
