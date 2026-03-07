test_that("add_on_ice_players(gc_pbp(), shift_chart()) returns non-empty data.frame", {
  skip_if_offline()
  test <- add_on_ice_players(gc_pbp(), shift_chart())
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("add_on_ice_players() returns aligned elapsed-seconds list columns", {
  play_by_play <- data.frame(
    gameId = c(1L, 1L, 1L, 1L),
    eventId = c(1L, 2L, 3L, 4L),
    period = c(1L, 1L, 1L, 2L),
    secondsElapsedInPeriod = c(5L, 10L, 10L, 10L),
    secondsElapsedInGame = c(5L, 10L, 10L, 1210L),
    sortOrder = c(1L, 2L, 3L, 4L),
    strengthState = c("ev", "ev", "ev", "ev"),
    typeDescKey = c("shot-on-goal", "shot-on-goal", "faceoff", "shot-on-goal"),
    isHome = c(TRUE, TRUE, TRUE, TRUE),
    situationCode = c("1551", "1551", "1551", "1551"),
    stringsAsFactors = FALSE
  )
  shift_chart <- data.frame(
    gameId = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
    teamId = c(10L, 10L, 10L, 20L, 20L, 20L, 10L, 20L),
    playerId = c(101L, 101L, 102L, 201L, 201L, 202L, 101L, 201L),
    period = c(1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L),
    startSecondsElapsedInGame = c(0L, 8L, 10L, 0L, 9L, 10L, 1205L, 1200L),
    endSecondsElapsedInGame = c(5L, 20L, 20L, 7L, 20L, 20L, 1220L, 1220L),
    isHome = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE)
  )

  out <- add_on_ice_players(play_by_play, shift_chart)
  idx <- match(
    c(
      "playerIdsAgainst", "homeSecondsElapsedInShift", "awaySecondsElapsedInShift",
      "secondsElapsedInShiftFor", "secondsElapsedInShiftAgainst",
      "homeSecondsElapsedInPeriodSinceLastShift",
      "awaySecondsElapsedInPeriodSinceLastShift",
      "secondsElapsedInPeriodSinceLastShiftFor",
      "secondsElapsedInPeriodSinceLastShiftAgainst"
    ),
    names(out)
  )

  expect_equal(idx, seq.int(idx[1], length.out = length(idx)))
  expect_equal(out$homePlayerIds[[1]], 101L)
  expect_equal(out$homeSecondsElapsedInShift[[1]], 5L)
  expect_equal(out$homeSecondsElapsedInPeriodSinceLastShift[[1]], 305L)
  expect_equal(out$awayPlayerIds[[2]], 201L)
  expect_equal(out$awaySecondsElapsedInShift[[2]], 1L)
  expect_equal(out$awaySecondsElapsedInPeriodSinceLastShift[[2]], 3L)
  expect_equal(out$homePlayerIds[[3]], c(101L, 102L))
  expect_equal(out$homeSecondsElapsedInShift[[3]], c(2L, 0L))
  expect_equal(out$awayPlayerIds[[3]], c(201L, 202L))
  expect_equal(out$awaySecondsElapsedInShift[[3]], c(1L, 0L))
  expect_equal(out$secondsElapsedInShiftFor[[3]], c(2L, 0L))
  expect_equal(out$secondsElapsedInShiftAgainst[[3]], c(1L, 0L))
  expect_equal(out$homeSecondsElapsedInPeriodSinceLastShift[[3]], c(5L, 310L))
  expect_equal(out$awaySecondsElapsedInPeriodSinceLastShift[[3]], c(3L, 310L))
  expect_equal(out$secondsElapsedInPeriodSinceLastShiftFor[[3]], c(5L, 310L))
  expect_equal(out$secondsElapsedInPeriodSinceLastShiftAgainst[[3]], c(3L, 310L))
  expect_equal(out$homePlayerIds[[4]], 101L)
  expect_equal(out$homeSecondsElapsedInShift[[4]], 5L)
  expect_equal(out$homeSecondsElapsedInPeriodSinceLastShift[[4]], 310L)
  expect_equal(out$awayPlayerIds[[4]], 201L)
  expect_equal(out$awaySecondsElapsedInShift[[4]], 10L)
  expect_equal(out$awaySecondsElapsedInPeriodSinceLastShift[[4]], 310L)
})

test_that("add_on_ice_players() keeps shootout scorer rows and sets elapsed columns to NA", {
  play_by_play <- data.frame(
    gameId = 1L,
    eventId = 1L,
    period = 5L,
    secondsElapsedInPeriod = 65L,
    secondsElapsedInGame = 65L,
    sortOrder = 1L,
    strengthState = "other",
    typeDescKey = "goal",
    isHome = TRUE,
    situationCode = "0101",
    scoringPlayerId = 11L,
    shootingPlayerId = NA_integer_,
    goalieInNetId = 31L,
    stringsAsFactors = FALSE
  )
  shift_chart <- data.frame(
    gameId = c(1L, 1L),
    teamId = c(10L, 20L),
    playerId = c(11L, 31L),
    period = c(5L, 5L),
    startSecondsElapsedInGame = c(60L, 0L),
    endSecondsElapsedInGame = c(70L, 70L),
    isHome = c(TRUE, FALSE)
  )

  out <- add_on_ice_players(play_by_play, shift_chart)

  expect_equal(out$playerIdsFor[[1]], 11L)
  expect_equal(out$playerIdsAgainst[[1]], 31L)
  expect_equal(out$homePlayerIds[[1]], 11L)
  expect_equal(out$awayPlayerIds[[1]], 31L)
  expect_equal(out$homeSecondsElapsedInShift[[1]], NA_integer_)
  expect_equal(out$awaySecondsElapsedInShift[[1]], NA_integer_)
  expect_equal(out$secondsElapsedInShiftFor[[1]], NA_integer_)
  expect_equal(out$secondsElapsedInShiftAgainst[[1]], NA_integer_)
  expect_equal(out$homeSecondsElapsedInPeriodSinceLastShift[[1]], NA_integer_)
  expect_equal(out$awaySecondsElapsedInPeriodSinceLastShift[[1]], NA_integer_)
  expect_equal(out$secondsElapsedInPeriodSinceLastShiftFor[[1]], NA_integer_)
  expect_equal(out$secondsElapsedInPeriodSinceLastShiftAgainst[[1]], NA_integer_)
})

test_that("add_on_ice_players() infers goalieInNetId for blocked shots from on-ice goalies", {
  local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = c(11L, 31L, 41L),
        positionCode = c("D", "G", "G"),
        stringsAsFactors = FALSE
      )
    },
    .package = "nhlscraper"
  )

  play_by_play <- data.frame(
    gameId = 1L,
    eventId = 1L,
    period = 1L,
    secondsElapsedInPeriod = 20L,
    secondsElapsedInGame = 20L,
    sortOrder = 1L,
    strengthState = "ev",
    typeDescKey = "blocked-shot",
    isHome = TRUE,
    isEmptyNetFor = FALSE,
    isEmptyNetAgainst = FALSE,
    goalieInNetId = NA_integer_,
    situationCode = "1551",
    stringsAsFactors = FALSE
  )
  shift_chart <- data.frame(
    gameId = c(1L, 1L, 1L),
    teamId = c(10L, 10L, 20L),
    playerId = c(11L, 31L, 41L),
    period = c(1L, 1L, 1L),
    startSecondsElapsedInGame = c(0L, 0L, 0L),
    endSecondsElapsedInGame = c(30L, 30L, 30L),
    isHome = c(TRUE, TRUE, FALSE)
  )

  out <- add_on_ice_players(play_by_play, shift_chart)

  expect_equal(out$playerIdsFor[[1]], c(11L, 31L))
  expect_equal(out$playerIdsAgainst[[1]], 41L)
  expect_equal(out$goalieInNetId[1], 41L)
})
