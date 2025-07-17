test_that('get_espn_event_odds() returns non-empty tibble', {
  skip_if_offline()
  test <- get_espn_event_odds()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_espn_event_odds(0) returns empty tibble', {
  skip_if_offline()
  test <- get_espn_event_odds(0)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
