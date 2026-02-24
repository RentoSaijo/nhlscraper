test_that("countries() returns non-empty data.frame", {
  skip_if_offline()
  test <- countries()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
