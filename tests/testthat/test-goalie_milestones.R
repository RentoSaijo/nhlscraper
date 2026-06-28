# Tests ---------------------------------------------------------

testthat::test_that('goalie_milestones() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- goalie_milestones()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
