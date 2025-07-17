test_that('get_award_winners() returns non-empty tibble', {
  skip_if_offline()
  test <- get_award_winners()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
