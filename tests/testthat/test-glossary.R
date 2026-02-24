test_that("glossary() returns non-empty data.frame", {
  skip_if_offline()
  test <- glossary()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

