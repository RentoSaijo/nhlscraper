test_that("goalie_edge_five_versus_five() returns non-empty list", {
  skip_if_offline()
  test <- goalie_edge_five_versus_five()
  expect_true(is.list(test) && length(test) > 0)
})

test_that("goalie_edge_five_versus_five(0) returns message and empty list", {
  skip_if_offline()
  expect_message(
    test <- goalie_edge_five_versus_five(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.list(test) && length(test) == 0)
})
