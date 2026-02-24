test_that("standings_rules() returns non-empty data.frame", {
  skip_if_offline()
  test <- standings_rules()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
