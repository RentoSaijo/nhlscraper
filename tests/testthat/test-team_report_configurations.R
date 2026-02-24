test_that("team_report_configurations() returns non-empty list", {
  skip_if_offline()
  test <- team_report_configurations()
  expect_true(is.list(test) && length(test) > 0)
})
