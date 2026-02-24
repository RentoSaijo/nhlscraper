test_that("goalie_edge_seasons() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_edge_seasons()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

