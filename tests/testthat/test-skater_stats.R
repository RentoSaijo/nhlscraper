test_that("skater_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- skater_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
