test_that("draft_picks() returns non-empty data.frame", {
  skip_if_offline()
  test <- draft_picks()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

