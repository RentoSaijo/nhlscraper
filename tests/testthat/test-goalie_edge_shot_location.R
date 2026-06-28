# Tests ---------------------------------------------------------

testthat::test_that('goalie_edge_shot_location() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- goalie_edge_shot_location()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run goalie edge shot location tests.
testthat::test_that('goalie_edge_shot_location(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- goalie_edge_shot_location(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
