test_that("calculate_speed(gc_pbp()) returns non-empty data.frame", {
  skip_if_offline()
  test <- calculate_speed(gc_pbp())
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
