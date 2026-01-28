test_that('shift_chart() returns non-empty data.frame', {
  skip_if_offline()
  test <- shift_chart()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('shift_chart(0) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- shift_chart(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
