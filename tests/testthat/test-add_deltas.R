test_that("add_deltas(gc_pbp()) returns non-empty data.frame", {
  skip_if_offline()
  test <- add_deltas(gc_pbp())
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("add_deltas() starts new sequences at faceoffs", {
  pbp <- data.frame(
    gameId = rep(1L, 11),
    eventId = seq_len(11),
    secondsElapsedInGame = c(9, 10, 10, 10, 11, 20, 20, 20, 20, 20, 21),
    xCoord = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    yCoord = rep(0, 11),
    xCoordNorm = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    yCoordNorm = rep(0, 11),
    distance = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    angle = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    eventTypeDescKey = c(
      "shot", "faceoff", "shot", "shot", "shot",
      "shot", "faceoff", "shot", "shot", "shot", "shot"
    ),
    situationCode = rep("1551", 11),
    sortOrder = seq_len(11)
  )

  out <- add_deltas(pbp)

  expect_true(is.na(out$dSecondsElapsedInSequence[2]))
  expect_true(is.na(out$dXCoordNorm[2]))
  expect_true(is.na(out$dSecondsElapsedInSequence[7]))
  expect_true(is.na(out$dXCoordNorm[7]))
  expect_true(is.na(out$secondsElapsedInSequence[1]))
  expect_equal(out$secondsElapsedInSequence[2], 0)
  expect_equal(out$secondsElapsedInSequence[5], 1)
  expect_equal(out$secondsElapsedInSequence[8], 0)
  expect_true(is.na(out$eventIdPrev[2]))
  expect_true(is.na(out$eventIdPrev[7]))
  expect_equal(out$dXCoord[8], 10)
  expect_equal(out$dXCoordNorm[8], 10)
  expect_equal(out$dSecondsElapsedInSequence[8], 0)
  expect_equal(out$eventIdPrev[8], 7)
})

test_that("add_deltas() preserves same-second internal rate scaling", {
  pbp <- data.frame(
    gameId = rep(1L, 11),
    eventId = seq_len(11),
    secondsElapsedInGame = c(9, 10, 10, 10, 11, 20, 20, 20, 20, 20, 21),
    xCoord = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    yCoord = rep(0, 11),
    xCoordNorm = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    yCoordNorm = rep(0, 11),
    distance = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    angle = c(1, 0, 3, 6, 10, 20, 50, 60, 70, 80, 90),
    eventTypeDescKey = c(
      "shot", "faceoff", "shot", "shot", "shot",
      "shot", "faceoff", "shot", "shot", "shot", "shot"
    ),
    situationCode = rep("1551", 11),
    sortOrder = seq_len(11)
  )

  out <- .compute_pbp_deltas(pbp)

  expect_equal(out$dSecondsElapsedInSequence[3], 0)
  expect_equal(out$dXCoordPerSecond[3], 9)
  expect_equal(out$dXCoordPerSecond[4], 9)
  expect_equal(out$dXCoordNormPerSecond[3], 9)
  expect_equal(out$dXCoordNormPerSecond[4], 9)
  expect_equal(out$dXCoordPerSecond[8], 40)
  expect_equal(out$dXCoordPerSecond[9], 40)
  expect_equal(out$dXCoordPerSecond[10], 40)
  expect_equal(out$dXCoordPerSecond[11], 10)
  expect_equal(out$dXCoordNormPerSecond[8], 40)
  expect_equal(out$dXCoordNormPerSecond[9], 40)
  expect_equal(out$dXCoordNormPerSecond[10], 40)
  expect_equal(out$dXCoordNormPerSecond[11], 10)
  expect_equal(out$dYCoordPerSecond[c(3, 4, 8, 9, 10, 11)], rep(0, 6))
})

test_that("add_deltas() respects game boundaries on aggregated inputs", {
  pbp <- data.frame(
    gameId = c(1L, 1L, 2L, 2L),
    eventId = c(101L, 102L, 201L, 202L),
    secondsElapsedInGame = c(10, 11, 10, 11),
    xCoord = c(0, 10, 5, 15),
    yCoord = c(0, 0, 1, 1),
    xCoordNorm = c(0, 10, 5, 15),
    yCoordNorm = c(0, 0, 1, 1),
    distance = c(0, 10, 5, 15),
    angle = c(0, 10, 5, 15),
    eventTypeDescKey = c("faceoff", "shot", "faceoff", "shot"),
    situationCode = rep("1551", 4),
    sortOrder = c(1L, 2L, 1L, 2L)
  )

  out <- add_deltas(pbp)

  expect_true(all(is.na(out$eventIdPrev[c(1L, 3L)])))
  expect_equal(out$eventIdPrev[c(2L, 4L)], c(101L, 201L))
  expect_equal(out$secondsElapsedInSequence[c(2L, 4L)], c(1, 1))
  expect_equal(out$dXCoord[c(2L, 4L)], c(10, 10))
})

test_that("add_deltas() leaves shootout and penalty-shot rows as NA", {
  pbp <- data.frame(
    gameId = rep(1L, 5),
    eventId = seq_len(5),
    secondsElapsedInGame = c(10, 11, 11, 12, 13),
    xCoord = c(0, 10, 20, 30, 40),
    yCoord = rep(0, 5),
    xCoordNorm = c(0, 10, 20, 30, 40),
    yCoordNorm = rep(0, 5),
    distance = c(0, 10, 20, 30, 40),
    angle = c(0, 10, 20, 30, 40),
    eventTypeDescKey = c("faceoff", "shot", "shot-on-goal", "goal", "shot"),
    situationCode = c("1551", "1551", "1010", "0101", "1551"),
    sortOrder = seq_len(5)
  )

  out <- add_deltas(pbp)

  expect_true(all(is.na(out[3, c(
    "dSecondsElapsedInSequence", "dXCoord", "dYCoord", "dXCoordNorm",
    "dYCoordNorm", "dDistance", "dAngle"
  )])))
  expect_true(all(is.na(out[4, c(
    "dSecondsElapsedInSequence", "dXCoord", "dYCoord", "dXCoordNorm",
    "dYCoordNorm", "dDistance", "dAngle"
  )])))
  expect_true(is.na(out$secondsElapsedInSequence[3]))
  expect_true(is.na(out$secondsElapsedInSequence[4]))
  expect_true(is.na(out$eventIdPrev[3]))
  expect_true(is.na(out$eventIdPrev[4]))
  expect_equal(out$dXCoord[5], 30)
  expect_equal(out$dSecondsElapsedInSequence[5], 2)
  expect_equal(out$eventIdPrev[5], 2)
  expect_equal(out$secondsElapsedInSequence[5], 3)
})

test_that("add_deltas() places secondsElapsedInSequence after shift-rest-against", {
  pbp <- data.frame(
    gameId = rep(1L, 3),
    eventId = seq_len(3),
    secondsElapsedInGame = c(10, 11, 12),
    xCoord = c(0, 10, 20),
    yCoord = c(0, 0, 0),
    xCoordNorm = c(0, 10, 20),
    yCoordNorm = c(0, 0, 0),
    distance = c(0, 10, 20),
    angle = c(0, 10, 20),
    secondsElapsedInPeriodSinceLastShiftAgainst = I(list(1L, 2L, 3L)),
    eventTypeDescKey = c("faceoff", "shot", "shot"),
    situationCode = rep("1551", 3),
    sortOrder = seq_len(3)
  )

  out <- add_deltas(pbp)
  cols <- names(out)

  expect_equal(
    match("secondsElapsedInSequence", cols),
    match("secondsElapsedInPeriodSinceLastShiftAgainst", cols) + 1L
  )
  expect_false(any(c(
    "dXN", "dYN", "dD", "dA", "dT", "dXNdT", "dYNdT", "dDdT", "dAdT"
  ) %in% cols))
  expect_true(all(c(
    "eventIdPrev", "dSecondsElapsedInSequence", "dXCoord", "dYCoord",
    "dXCoordNorm", "dYCoordNorm", "dDistance", "dAngle",
    "dXCoordPerSecond", "dYCoordPerSecond", "dXCoordNormPerSecond",
    "dYCoordNormPerSecond", "dDistancePerSecond", "dAnglePerSecond"
  ) %in% cols))
  expect_equal(
    cols[(match("dAngle", cols) + 1L):(match("dAngle", cols) + 6L)],
    c(
      "dXCoordPerSecond", "dYCoordPerSecond", "dXCoordNormPerSecond",
      "dYCoordNormPerSecond", "dDistancePerSecond", "dAnglePerSecond"
    )
  )
})
