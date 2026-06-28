# Tests ---------------------------------------------------------

testthat::test_that('draft_rankings(2025) returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- draft_rankings(2025)
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})

# Run draft rankings tests.
testthat::test_that('draft_rankings(20242025) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- draft_rankings(20242025),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})
