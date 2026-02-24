test_that("franchise_vs_franchise() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchise_vs_franchise()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

