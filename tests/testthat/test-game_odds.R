test_that("game_odds() returns non-empty data.frame", {
  skip_if_offline()
  test <- game_odds()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("game_odds('USA') returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- game_odds('USA'),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

