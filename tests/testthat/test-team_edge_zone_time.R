test_that("team_edge_zone_time() returns non-empty data.frame", {
  skip_if_offline()
  test <- team_edge_zone_time()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("team_edge_zone_time(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- team_edge_zone_time(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

