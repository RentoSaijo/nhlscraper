test_that("calculate_speed(gc_pbp()) returns non-empty data.frame", {
  skip_if_offline()
  test <- calculate_speed(gc_pbp())
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("calculate_speed() starts new sequences at faceoffs", {
  pbp <- data.frame(
    gameId = rep(1L, 11),
    eventId = seq_len(11),
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
  expect_true(is.na(out$secondsElapsedInSequence[1]))
  expect_equal(out$secondsElapsedInSequence[2], 0)
  expect_equal(out$secondsElapsedInSequence[5], 1)
  expect_equal(out$secondsElapsedInSequence[8], 0)
  expect_true(is.na(out$eventIdPrev[2]))
  expect_true(is.na(out$eventIdPrev[7]))
  expect_equal(out$dXN[8], 10)
  expect_equal(out$dT[8], 0)
  expect_equal(out$eventIdPrev[8], 7)
})

test_that("calculate_speed() scales same-second rates by events in the faceoff sequence", {
  pbp <- data.frame(
    gameId = rep(1L, 11),
    eventId = seq_len(11),
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

test_that("calculate_speed() leaves shootout and penalty-shot rows as NA", {
  pbp <- data.frame(
    gameId = rep(1L, 5),
    eventId = seq_len(5),
    secondsElapsedInGame = c(10, 11, 11, 12, 13),
    xCoordNorm = c(0, 10, 20, 30, 40),
    yCoordNorm = rep(0, 5),
    distance = c(0, 10, 20, 30, 40),
    angle = c(0, 10, 20, 30, 40),
    typeDescKey = c("faceoff", "shot", "shot-on-goal", "goal", "shot"),
    situationCode = c("1551", "1551", "1010", "0101", "1551"),
    sortOrder = seq_len(5)
  )

  out <- calculate_speed(pbp)

  expect_true(all(is.na(out[3, c("dXN", "dYN", "dD", "dA", "dT", "dXNdT", "dYNdT", "dDdT", "dAdT")])))
  expect_true(all(is.na(out[4, c("dXN", "dYN", "dD", "dA", "dT", "dXNdT", "dYNdT", "dDdT", "dAdT")])))
  expect_true(is.na(out$secondsElapsedInSequence[3]))
  expect_true(is.na(out$secondsElapsedInSequence[4]))
  expect_true(is.na(out$eventIdPrev[3]))
  expect_true(is.na(out$eventIdPrev[4]))
  expect_equal(out$dXN[5], 30)
  expect_equal(out$dT[5], 2)
  expect_equal(out$eventIdPrev[5], 2)
  expect_equal(out$secondsElapsedInSequence[5], 3)
})

test_that("calculate_speed() places secondsElapsedInSequence after shift-rest-against", {
  pbp <- data.frame(
    gameId = rep(1L, 3),
    eventId = seq_len(3),
    secondsElapsedInGame = c(10, 11, 12),
    xCoordNorm = c(0, 10, 20),
    yCoordNorm = c(0, 0, 0),
    distance = c(0, 10, 20),
    angle = c(0, 10, 20),
    secondsElapsedInPeriodSinceLastShiftAgainst = I(list(1L, 2L, 3L)),
    typeDescKey = c("faceoff", "shot", "shot"),
    sortOrder = seq_len(3)
  )

  out <- calculate_speed(pbp)
  cols <- names(out)

  expect_equal(
    match("secondsElapsedInSequence", cols),
    match("secondsElapsedInPeriodSinceLastShiftAgainst", cols) + 1L
  )
})
