test_that('get_configuration() returns non-empty list', {
  skip_if_offline()
  test <- get_configuration()
  expect_true(is.list(test) && length(test)>0)
})
