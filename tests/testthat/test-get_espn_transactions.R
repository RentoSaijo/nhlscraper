test_that('get_espn_transactions() returns non-empty tibble', {
  skip_if_offline()
  test <- get_espn_transactions()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_espn_transactions(18000101, 19000101) returns empty tibble', {
  skip_if_offline()
  test <- get_espn_transactions(18000101, 19000101)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
