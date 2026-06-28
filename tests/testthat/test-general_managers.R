# Tests ---------------------------------------------------------

testthat::test_that('general_managers() returns non-empty data.frame', {
  testthat::skip_if_offline()
  test <- general_managers()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
})
