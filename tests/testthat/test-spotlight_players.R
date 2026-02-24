test_that("spotlight_players() returns non-empty data.frame", {
  skip_if_offline()
  test <- spotlight_players()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
