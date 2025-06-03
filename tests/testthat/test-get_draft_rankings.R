test_that("get_draft_rankings() returns non-empty tibble", {
  skip_if_offline()
  test <- get_draft_rankings()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that("get_draft_rankings(1900) returns empty tibble", {
  skip_if_offline()
  test <- get_draft_rankings(1900)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
