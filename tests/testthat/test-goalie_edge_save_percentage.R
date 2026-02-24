test_that("goalie_edge_save_percentage() returns non-empty list", {
  skip_if_offline()
  test <- goalie_edge_save_percentage()
  expect_true(is.list(test) && length(test) > 0)
})

test_that("goalie_edge_save_percentage(0) returns message and empty list", {
  skip_if_offline()
  expect_message(
    test <- goalie_edge_save_percentage(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.list(test) && length(test) == 0)
})
