test_that("franchise_season_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchise_season_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

