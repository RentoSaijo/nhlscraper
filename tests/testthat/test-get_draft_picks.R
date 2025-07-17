test_that("get_draft_picks() returns non-empty tibble", {
  skip_if_offline()
  test <- get_draft_picks()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
