test_that("goalie_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

