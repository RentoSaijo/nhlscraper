test_that("coaches() returns non-empty data.frame", {
  skip_if_offline()
  test <- coaches()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
