# Tests ---------------------------------------------------------

testthat::test_that('glossary() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- glossary()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
