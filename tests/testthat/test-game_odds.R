# Tests ---------------------------------------------------------

testthat::test_that('game_odds() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- game_odds()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run game odds tests.
testthat::test_that('game_odds(\'USA\') returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- game_odds('USA'),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
