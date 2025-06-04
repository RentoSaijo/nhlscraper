test_that('get_glossary() returns non-empty tibble', {
  skip_if_offline()
  test <- get_glossary()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})
