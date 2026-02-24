test_that("franchises() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchises()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

