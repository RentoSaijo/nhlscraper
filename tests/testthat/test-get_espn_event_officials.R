test_that('get_espn_event_officials() returns non-empty tibble', {
  skip_if_offline()
  test <- get_espn_event_officials()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_espn_event_officials(0) returns empty tibble', {
  skip_if_offline()
  test <- get_espn_event_officials(0)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
