test_that('get_series_carousel(20242025) returns non-empty tibble', {
  skip_if_offline()
  test <- get_series_carousel(20242025)
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_series_carousel(19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_series_carousel(19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
