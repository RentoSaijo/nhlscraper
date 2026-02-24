test_that("skater_edge_seasons() returns non-empty data.frame", {
  skip_if_offline()
  test <- skater_edge_seasons()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
