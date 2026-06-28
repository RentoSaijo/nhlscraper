# Tests ---------------------------------------------------------

testthat::test_that('gc_play_by_play() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- gc_play_by_play()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run gc play by play tests.
testthat::test_that('gc_play_by_play(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- gc_play_by_play(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
