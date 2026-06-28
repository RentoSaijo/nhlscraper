# Tests ---------------------------------------------------------

testthat::test_that('expansion_drafts() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- expansion_drafts()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
