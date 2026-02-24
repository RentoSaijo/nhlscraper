test_that("combine_reports() returns non-empty data.frame", {
  skip_if_offline()
  test <- combine_reports()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

