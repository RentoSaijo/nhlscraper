test_that("goalie_report_configs() returns non-empty list", {
  skip_if_offline()
  test <- goalie_report_configs()
  expect_true(is.list(test) && length(test) > 0)
})
