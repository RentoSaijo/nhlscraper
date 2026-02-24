test_that("game_type_now() returns scalar integer", {
  skip_if_offline()
  test <- game_type_now()
  expect_true(is.integer(test) && length(test) == 1)
})
