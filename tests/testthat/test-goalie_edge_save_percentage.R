# Tests ---------------------------------------------------------

testthat::test_that('goalie_edge_save_percentage() returns non-empty list', {
  testthat::skip_if_offline()
  test <- goalie_edge_save_percentage()
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run goalie edge save percentage tests.
testthat::test_that('goalie_edge_save_percentage(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- goalie_edge_save_percentage(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
