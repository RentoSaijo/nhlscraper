test_that("team_prospects() returns non-empty data.frame", {
  skip_if_offline()
  test <- team_prospects()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("team_prospects(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- team_prospects(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

