test_that("franchise_playoff_situational_results() returns non-empty data.frame", {
  skip_if_offline()
  test <- franchise_playoff_situational_results()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

