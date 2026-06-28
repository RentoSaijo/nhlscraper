# Tests ---------------------------------------------------------

testthat::test_that('skater_edge_shot_speed() returns non-empty list', {
  testthat::skip_if_offline()
  test <- skater_edge_shot_speed()
  testthat::expect_true(is.list(test) && length(test) > 0)
})

# Run skater edge shot speed tests.
testthat::test_that('skater_edge_shot_speed(0) returns message and empty list', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- skater_edge_shot_speed(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.list(test) && length(test) == 0)
})
