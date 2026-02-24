test_that("general_managers() returns non-empty data.frame", {
  skip_if_offline()
  test <- general_managers()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
