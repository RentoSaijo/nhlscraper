test_that("espn_injuries() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_injuries()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
