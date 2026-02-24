test_that("goalie_statistics() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_statistics()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
