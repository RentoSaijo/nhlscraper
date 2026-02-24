test_that("standings('2025-01-01') returns non-empty data.frame", {
  skip_if_offline()
  test <- standings('2025-01-01')
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("standings(20250101) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- standings(20250101),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
