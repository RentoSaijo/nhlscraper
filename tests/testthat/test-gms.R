test_that("gms() returns non-empty data.frame", {
  skip_if_offline()
  test <- gms()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

