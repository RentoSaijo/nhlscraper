test_that("award_winners() returns non-empty data.frame", {
  skip_if_offline()
  test <- award_winners()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

