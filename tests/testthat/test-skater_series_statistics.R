test_that("skater_series_statistics() returns non-empty data.frame", {
  skip_if_offline()
  test <- skater_series_statistics()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
