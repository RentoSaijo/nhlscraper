test_that('shifts() returns non-empty data.frame', {
  skip_if_offline()
  test <- shifts()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('shifts(0) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- shifts(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
