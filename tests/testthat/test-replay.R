test_that('replay() returns non-empty data.frame', {
  skip_if_offline()
  test <- replay()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('replay(0) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- replay(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
