test_that('wsc_pbp() returns non-empty data.frame', {
  skip_if_offline()
  test <- wsc_pbp()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('wsc_pbp(0) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- wsc_pbp(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
