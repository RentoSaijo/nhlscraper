test_that("goalie_leaders(20242025, 3) returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_leaders(20242025, 3)
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("goalie_leaders(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- goalie_leaders(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
