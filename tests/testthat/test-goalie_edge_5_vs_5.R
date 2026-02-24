test_that("goalie_edge_5_vs_5() returns non-empty list", {
  skip_if_offline()
  test <- goalie_edge_5_vs_5()
  expect_true(is.list(test) && length(test) > 0)
})

