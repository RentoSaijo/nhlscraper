test_that("franchise_versus_franchise() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchise_versus_franchise()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
