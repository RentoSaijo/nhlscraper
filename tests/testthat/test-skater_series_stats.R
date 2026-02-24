test_that("skater_series_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- skater_series_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

