test_that("skater_milestones() returns non-empty data.frame", {
  skip_if_offline()
  test <- skater_milestones()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

