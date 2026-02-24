test_that("expansion_draft_picks() returns non-empty data.frame", {
  skip_if_offline()
  test <- expansion_draft_picks()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
