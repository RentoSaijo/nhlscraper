test_that("ping() returns TRUE on success", {
  skip_if_offline()
  expect_true(ping())
})
