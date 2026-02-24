test_that("franchise_team_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchise_team_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

