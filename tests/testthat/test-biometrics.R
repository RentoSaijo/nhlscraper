test_that("add_shooter_biometrics() keeps blocked shots and returns simplified columns", {
  local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = 10L,
        height = 72L,
        weight = 190L,
        handCode = "L",
        positionCode = "C",
        birthDate = "2000-01-01",
        stringsAsFactors = FALSE
      )
    },
    games = function() {
      data.frame(
        gameId = 1L,
        gameDate = "2025-01-10",
        stringsAsFactors = FALSE
      )
    },
    .package = "nhlscraper"
  )

  play_by_play <- data.frame(
    gameId = 1L,
    typeDescKey = "blocked-shot",
    scoringPlayerId = NA_integer_,
    shootingPlayerId = 10L,
    stringsAsFactors = FALSE
  )

  out <- add_shooter_biometrics(play_by_play)

  expect_equal(out$shooterHeight, 72L)
  expect_equal(out$shooterWeight, 190L)
  expect_equal(out$shooterHandCode, "L")
  expect_equal(out$shooterAge, 25L)
  expect_equal(out$shooterPositionCode, "C")
  expect_false("shooterSide" %in% names(out))
})

test_that("add_goalie_biometrics() leaves missing blocked-shot goalies as NA", {
  local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = 30L,
        height = 74L,
        weight = 185L,
        handCode = "R",
        birthDate = "1998-01-01",
        stringsAsFactors = FALSE
      )
    },
    games = function() {
      data.frame(
        gameId = 1L,
        gameDate = "2025-01-10",
        stringsAsFactors = FALSE
      )
    },
    .package = "nhlscraper"
  )

  play_by_play <- data.frame(
    gameId = c(1L, 1L),
    eventTypeDescKey = c("blocked-shot", "blocked-shot"),
    goaliePlayerIdAgainst = c(NA_integer_, 30L),
    stringsAsFactors = FALSE
  )

  out <- add_goalie_biometrics(play_by_play)

  expect_true(all(is.na(out$goalieHeight[1])))
  expect_true(all(is.na(out$goalieWeight[1])))
  expect_true(all(is.na(out$goalieHandCode[1])))
  expect_true(all(is.na(out$goalieAge[1])))
  expect_equal(out$goalieHeight[2], 74L)
  expect_equal(out$goalieWeight[2], 185L)
  expect_equal(out$goalieHandCode[2], "R")
  expect_equal(out$goalieAge[2], 27L)
  expect_false("goalieSide" %in% names(out))
})

test_that("biometrics helpers respect game dates on aggregated inputs", {
  local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = c(10L, 30L),
        height = c(72L, 74L),
        weight = c(190L, 185L),
        handCode = c("L", "R"),
        positionCode = c("C", NA_character_),
        birthDate = c("2000-01-01", "1998-01-01"),
        stringsAsFactors = FALSE
      )
    },
    games = function() {
      data.frame(
        gameId = c(1L, 2L),
        gameDate = c("2025-01-10", "2026-01-10"),
        stringsAsFactors = FALSE
      )
    },
    .package = "nhlscraper"
  )

  shooter_pbp <- data.frame(
    gameId = c(1L, 2L),
    scoringPlayerId = c(NA_integer_, NA_integer_),
    shootingPlayerId = c(10L, 10L),
    stringsAsFactors = FALSE
  )
  goalie_pbp <- data.frame(
    gameId = c(1L, 2L),
    goaliePlayerIdAgainst = c(30L, 30L),
    stringsAsFactors = FALSE
  )

  shooter_out <- add_shooter_biometrics(shooter_pbp)
  goalie_out <- add_goalie_biometrics(goalie_pbp)

  expect_equal(shooter_out$shooterAge, c(25L, 26L))
  expect_equal(goalie_out$goalieAge, c(27L, 28L))
  expect_equal(shooter_out$shooterHeight, c(72L, 72L))
  expect_equal(goalie_out$goalieHeight, c(74L, 74L))
})
