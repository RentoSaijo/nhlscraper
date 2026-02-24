test_that("goalie_report_configurations() returns non-empty list", {
  skip_if_offline()
  test <- goalie_report_configurations()
  expect_true(is.list(test) && length(test) > 0)
})
