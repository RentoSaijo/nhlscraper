test_that("calculate_speed(gc_pbp()) returns non-empty data.frame", {
  skip_if_offline()
  test <- calculate_speed(gc_pbp())
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("calculate_speed() starts new sequences at faceoffs", {
  pbp <- data.frame(
    gameId = rep(1L, 11),
    secondsElapsedInGame = c(9, 10, 10, 10, 11, 20, 20, 20, 20, 20, 21),
    xCoordNorm = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    yCoordNorm = rep(0, 11),
    distance = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    angle = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    typeDescKey = c(
      "shot", "faceoff", "shot", "shot", "shot",
      "shot", "faceoff", "shot", "shot", "shot", "shot"
    ),
    sortOrder = seq_len(11)
  )

  out <- calculate_speed(pbp)

  expect_true(is.na(out$dT[2]))
  expect_true(is.na(out$dXN[2]))
  expect_true(is.na(out$dT[7]))
  expect_true(is.na(out$dXN[7]))
  expect_equal(out$dXN[8], 10)
  expect_equal(out$dT[8], 0)
})

test_that("calculate_speed() scales same-second rates by events in the faceoff sequence", {
  pbp <- data.frame(
    gameId = rep(1L, 11),
    secondsElapsedInGame = c(9, 10, 10, 10, 11, 20, 20, 20, 20, 20, 21),
    xCoordNorm = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    yCoordNorm = rep(0, 11),
    distance = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    angle = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    typeDescKey = c(
      "shot", "faceoff", "shot", "shot", "shot",
      "shot", "faceoff", "shot", "shot", "shot", "shot"
    ),
    sortOrder = seq_len(11)
  )

  out <- calculate_speed(pbp)

  expect_equal(out$dT[3], 0)
  expect_equal(out$dXNdT[3], 9)
  expect_equal(out$dXNdT[4], 9)
  expect_equal(out$dXNdT[8], 40)
  expect_equal(out$dXNdT[9], 40)
  expect_equal(out$dXNdT[10], 40)
  expect_equal(out$dXNdT[11], 10)
})
