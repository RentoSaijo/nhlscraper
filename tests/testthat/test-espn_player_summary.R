test_that("espn_player_summary() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_player_summary()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("espn_player_summary(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- espn_player_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

