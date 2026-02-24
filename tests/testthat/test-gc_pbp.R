test_that("gc_pbp() returns non-empty data.frame", {
  skip_if_offline()
  test <- gc_pbp()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

