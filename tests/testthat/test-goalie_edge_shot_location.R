test_that("goalie_edge_shot_location() returns non-empty data.frame", {
  skip_if_offline()
  test <- goalie_edge_shot_location()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("goalie_edge_shot_location(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- goalie_edge_shot_location(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})
