test_that("roster(1, 20242025, 'forwards') returns non-empty data.frame", {
  skip_if_offline()
  test <- roster(1, 20242025, 'forwards')
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("roster(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- roster(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
