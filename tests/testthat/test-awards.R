test_that("awards() returns non-empty data.frame", {
  skip_if_offline()
  test <- awards()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

