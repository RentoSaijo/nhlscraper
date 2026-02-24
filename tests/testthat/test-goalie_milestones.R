test_that("goalie_milestones() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_milestones()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
