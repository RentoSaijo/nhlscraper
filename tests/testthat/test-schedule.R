test_that("schedule('2025-01-01') returns data.frame", {
  skip_if_offline()
  test <- schedule('2025-01-01')
  expect_true(is.data.frame(test))
})

test_that("schedule(20250101) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- schedule(20250101),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

