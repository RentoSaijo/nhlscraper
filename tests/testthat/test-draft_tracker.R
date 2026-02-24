test_that("draft_tracker() returns non-empty data.frame", {
  skip_if_offline()
  test <- draft_tracker()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

