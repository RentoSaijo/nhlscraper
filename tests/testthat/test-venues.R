test_that("venues() returns non-empty data.frame", {
  skip_if_offline()
  test <- venues()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

