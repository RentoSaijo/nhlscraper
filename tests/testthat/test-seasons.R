test_that("seasons() returns non-empty data.frame", {
  skip_if_offline()
  test <- seasons()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

