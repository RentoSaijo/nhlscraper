test_that("season_now() returns scalar integer", {
  skip_if_offline()
  test <- season_now()
  expect_true(is.integer(test) && length(test) == 1)
})
