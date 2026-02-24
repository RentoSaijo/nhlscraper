test_that("draw_NHL_rink() returns NULL", {
  skip_if_offline()
  test <- draw_NHL_rink()
  expect_null(test)
})
