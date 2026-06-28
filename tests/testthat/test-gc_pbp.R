# Tests ---------------------------------------------------------

testthat::test_that('gc_pbp() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- gc_pbp()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
