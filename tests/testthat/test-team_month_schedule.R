test_that("team_month_schedule(1, '2025-01') returns non-empty data.frame", {
  skip_if_offline()
  test <- team_month_schedule(1, '2025-01')
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("team_month_schedule(1, 0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- team_month_schedule(1, 0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
