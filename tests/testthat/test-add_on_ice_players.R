test_that("add_on_ice_players(gc_pbp(), shift_chart()) returns non-empty data.frame", {
  skip_if_offline()
  test <- add_on_ice_players(gc_pbp(), shift_chart())
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

