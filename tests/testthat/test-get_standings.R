test_that('get_standings() returns non-empty tibble', {
  skip_if_offline()
  test <- get_standings()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_standings(\'1900-01-01\') returns empty tibble', {
  skip_if_offline()
  test <- get_standings('1900-01-01')
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})

test_that('get_standings(\'2025-1-1\') returns error', {
  skip_if_offline()
  expect_error(
    get_standings('2025-1-1'),
    '`date` must be in \'YYYY-MM-DD\' format'
  )
})
