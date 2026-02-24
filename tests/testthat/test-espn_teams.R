test_that("espn_teams() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_teams()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

