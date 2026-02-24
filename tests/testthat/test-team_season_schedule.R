test_that("team_season_schedule(1, 20242025) returns non-empty data.frame", {
  skip_if_offline()
  test <- team_season_schedule(1, 20242025)
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("team_season_schedule(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- team_season_schedule(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

