test_that("team_edge_summary() returns non-empty list", {
  skip_if_offline()
  test <- team_edge_summary()
  expect_true(is.list(test) && length(test) > 0)
})

test_that("team_edge_summary(0) returns message and empty list", {
  skip_if_offline()
  expect_message(
    test <- team_edge_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.list(test) && length(test) == 0)
})

