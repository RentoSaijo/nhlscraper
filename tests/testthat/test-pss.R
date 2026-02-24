test_that("pss() returns non-empty data.frame", {
  skip_if_offline()
  test <- pss()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
