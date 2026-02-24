test_that("location() returns non-empty data.frame", {
  skip_if_offline()
  test <- location()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("location(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- location(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

