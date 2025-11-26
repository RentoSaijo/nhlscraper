test_that(
  'team_week_schedule(1, \'2025-01-01\') returns non-empty data.frame', {
  skip_if_offline()
  test <- team_week_schedule(1, '2025-01-01')
  expect_true(is.data.frame(test) && nrow(test) > 0)
  }
)

test_that(
  'team_week_schedule(1, 202501) returns message and empty data.frame', {
    skip_if_offline()
    expect_message(
      test <- team_week_schedule(1, 20250101),
      'Invalid argument\\(s\\); refer to help file\\.'
    )
    expect_true(is.data.frame(test) && nrow(test) == 0)
  }
)
