test_that("series() returns non-empty data.frame", {
  skip_if_offline()
  test <- series()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

