test_that("expansion_drafts() returns non-empty data.frame", {
  skip_if_offline()
  test <- expansion_drafts()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

