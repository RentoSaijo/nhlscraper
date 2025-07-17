test_that('get_espn_team() returns non-empty list', {
  skip_if_offline()
  test <- get_espn_team()
  expect_true(is.list(test) && length(test)>0)
})

test_that('get_espn_team(0) returns empty list', {
  skip_if_offline()
  test <- get_espn_team(0)
  expect_true(is.list(test) && length(test)==1)
})
