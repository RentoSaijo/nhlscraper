test_that("team_edge_seasons() returns non-empty data.frame", {
  skip_if_offline()
  test <- team_edge_seasons()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

