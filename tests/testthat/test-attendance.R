test_that("attendance() returns non-empty data.frame", {
  skip_if_offline()
  test <- attendance()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

