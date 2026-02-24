test_that("contracts() returns non-empty data.frame", {
  skip_if_offline()
  test <- contracts()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

