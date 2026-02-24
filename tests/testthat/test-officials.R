test_that("officials() returns non-empty data.frame", {
  skip_if_offline()
  test <- officials()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
