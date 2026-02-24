test_that("drafts() returns non-empty data.frame", {
  skip_if_offline()
  test <- drafts()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

