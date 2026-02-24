test_that("streams() returns data.frame", {
  skip_if_offline()
  test <- streams()
  expect_true(is.data.frame(test))
})

