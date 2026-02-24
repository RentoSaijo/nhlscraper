test_that("players() returns non-empty data.frame", {
  skip_if_offline()
  test <- players()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
