test_that("espn_players() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_players()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

