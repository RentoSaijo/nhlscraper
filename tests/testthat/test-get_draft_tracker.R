test_that('get_draft_tracker() returns non-empty tibble', {
  test <- get_draft_tracker()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
