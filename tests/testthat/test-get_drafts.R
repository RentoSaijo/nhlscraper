test_that('get_drafts() returns non-empty tibble', {
  skip_if_offline()
  test <- get_drafts()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
