test_that('get_skater_leaders() returns non-empty tibble', {
  skip_if_offline()
  test <- get_skater_leaders()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_skater_leaders(19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_skater_leaders(19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
