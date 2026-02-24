test_that("team_season_statistics() returns non-empty data.frame", {
  skip_if_offline()
  test <- team_season_statistics()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
