test_that("skater_edge_summary() returns non-empty list", {
  skip_if_offline()
  test <- skater_edge_summary()
  expect_true(is.list(test) && length(test) > 0)
})

test_that("skater_edge_summary(0) returns message and empty list", {
  skip_if_offline()
  expect_message(
    test <- skater_edge_summary(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.list(test) && length(test) == 0)
})
