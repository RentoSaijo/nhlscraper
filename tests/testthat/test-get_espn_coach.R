test_that('get_espn_coach() returns non-empty list', {
  skip_if_offline()
  test <- get_espn_coach()
  expect_true(is.list(test) && length(test)>0)
})

test_that('get_espn_coach(0) returns empty list', {
  skip_if_offline()
  test <- get_espn_coach(0)
  expect_true(is.list(test) && length(test)==1)
})
