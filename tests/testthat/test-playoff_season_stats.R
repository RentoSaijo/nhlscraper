test_that("playoff_season_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- playoff_season_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
