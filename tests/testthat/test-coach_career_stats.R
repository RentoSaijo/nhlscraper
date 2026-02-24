test_that("coach_career_stats() returns non-empty data.frame", {
  skip_if_offline()
  test <- coach_career_stats()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})
