test_that('get_gc_play_by_play() returns non-empty tibble', {
  skip_if_offline()
  test <- get_gc_play_by_play()
  expect_true(tibble::is_tibble(test) && nrow(test)>0)
})

test_that('get_gc_play_by_play(0) returns empty tibble', {
  skip_if_offline()
  test <- get_gc_play_by_play(0)
  expect_true(tibble::is_tibble(test) && nrow(test)==0)
})
