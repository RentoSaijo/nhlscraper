# Tests ---------------------------------------------------------

testthat::test_that('wsc_play_by_play() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- wsc_play_by_play()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run wsc play by play tests.
testthat::test_that('wsc_play_by_play(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- wsc_play_by_play(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
