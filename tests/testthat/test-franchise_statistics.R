test_that("franchise_statistics() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchise_statistics()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

