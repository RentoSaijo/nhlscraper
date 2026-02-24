test_that("teams() returns non-empty data.frame", {
  skip_if_offline()
  test <- teams()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

