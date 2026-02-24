test_that("lottery_odds() returns non-empty data.frame", {
  skip_if_offline()
  test <- lottery_odds()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
