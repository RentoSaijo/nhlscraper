# Tests ---------------------------------------------------------

testthat::test_that('goalie_season_report(20242025, 3) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- goalie_season_report(20242025, 3)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run goalie season report tests.
testthat::test_that('goalie_season_report(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- goalie_season_report(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
