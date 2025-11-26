test_that('series_schedule(20242025) returns non-empty data.frame', {
  skip_if_offline()
  test <- series_schedule(20242025)
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('series_schedule(2025) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- series_schedule(2025),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
