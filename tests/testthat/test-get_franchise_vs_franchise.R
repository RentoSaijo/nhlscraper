test_that('get_franchise_vs_franchise() returns non-empty tibble', {
  skip_if_offline()
  test <- get_franchise_vs_franchise()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
