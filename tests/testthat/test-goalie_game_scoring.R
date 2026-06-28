# Tests ---------------------------------------------------------

testthat::test_that('goalie_game_scoring() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- goalie_game_scoring()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
