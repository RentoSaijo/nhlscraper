test_that('get_espn_athlete() returns non-empty list', {
  skip_if_offline()
  test <- get_espn_athlete()
  expect_true(is.list(test) && length(test)>0)
})

test_that('get_espn_athlete(0) returns empty list', {
  skip_if_offline()
  test <- get_espn_athlete(0)
  expect_true(is.list(test) && length(test)==1)
})
