test_that("draft_rankings(2025) returns non-empty data.frame", {
  skip_if_offline()
  test <- draft_rankings(2025)
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("draft_rankings(20242025) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- draft_rankings(20242025),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

