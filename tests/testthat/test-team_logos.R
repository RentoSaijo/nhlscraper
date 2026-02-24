test_that("team_logos() returns non-empty data.frame", {
  skip_if_offline()
  test <- team_logos()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
