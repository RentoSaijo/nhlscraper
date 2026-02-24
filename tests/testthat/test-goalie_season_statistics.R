test_that("goalie_season_statistics() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_season_statistics()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

