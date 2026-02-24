test_that("espn_games() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_games()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("espn_games(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- espn_games(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

