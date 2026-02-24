test_that("goalie_scoring() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_scoring()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

