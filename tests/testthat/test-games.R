test_that("games() returns non-empty data.frame", {
  skip_if_offline()
  test <- games()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

