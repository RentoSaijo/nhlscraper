test_that('skater_game_report(20242025, 3) returns non-empty data.frame', {
  skip_if_offline()
  test <- skater_game_report(20242025, 3)
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that('skater_game_report(2025) returns message and empty data.frame', {
  skip_if_offline()
  expect_message(
    test <- skater_game_report(2025),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
