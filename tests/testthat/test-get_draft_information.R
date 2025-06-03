test_that("get_draft_information() returns non-empty tibble", {
  skip_if_offline()
  test <- get_draft_information()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
