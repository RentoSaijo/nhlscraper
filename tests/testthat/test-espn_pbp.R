test_that("espn_pbp() returns non-empty data.frame", {
  skip_if_offline()
  test <- espn_pbp()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
