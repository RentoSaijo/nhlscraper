test_that('get_goalie_milestones() returns non-empty tibble', {
  skip_if_offline()
  test <- get_goalie_milestones()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
