# Tests ---------------------------------------------------------

testthat::test_that('expansion_draft_picks() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- expansion_draft_picks()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
