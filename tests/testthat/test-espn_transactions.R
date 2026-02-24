test_that("espn_transactions() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_transactions()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("espn_transactions(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- espn_transactions(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

