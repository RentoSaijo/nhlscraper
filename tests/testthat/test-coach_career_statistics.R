# Tests ---------------------------------------------------------

testthat::test_that('coach_career_statistics() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- coach_career_statistics()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
