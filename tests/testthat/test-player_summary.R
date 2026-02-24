test_that("player_summary(8478402) returns non-empty list", {
  skip_if_offline()
  test <- player_summary(8478402)
  expect_true(is.list(test) && length(test) > 0)
})

test_that("player_summary(0) returns message and empty list", {
  skip_if_offline()
  expect_message(
    test <- player_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.list(test) && length(test) == 0)
})
