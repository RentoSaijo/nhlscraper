test_that('get_skater_statistics() returns non-empty tibble', {
  skip_if_offline()
  test <- get_skater_statistics()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_skater_statistics(19001901) returns empty tibble', {
  skip_if_offline()
  test <- get_skater_statistics(19001901)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})

test_that('get_skater_statistics(
          is_game=T, dates=c(\'2025-1-1\')
          ) returns error', {
  skip_if_offline()
  expect_error(
    get_skater_statistics(is_game=T, dates=c('2025-1-1')),
    'date in `dates` must be in \'YYYY-MM-DD\' format'
  )
})
