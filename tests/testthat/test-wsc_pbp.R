test_that("wsc_pbp() returns non-empty data.frame", {
  skip_if_offline()
  test <- wsc_pbp()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

