test_that("penalty_shots() returns non-empty data.frame", {
  skip_if_offline()
  test <- penalty_shots()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
