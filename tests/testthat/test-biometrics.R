# Tests ---------------------------------------------------------

testthat::test_that('add_shooter_biometrics() keeps blocked shots and returns simplified columns', {
  testthat::local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = 10L,
        height = 72L,
        weight = 190L,
        handCode = 'L',
        positionCode = 'C',
        birthDate = '2000-01-01',
        stringsAsFactors = FALSE
      )
    },
    games = function() {
      data.frame(
        gameId = 1L,
        gameDate = '2025-01-10',
        stringsAsFactors = FALSE
      )
    },
    .package = 'nhlscraper'
  )
  play_by_play <- data.frame(
    gameId = 1L,
    scoringPlayerId = NA_integer_,
    shootingPlayerId = 10L,
    stringsAsFactors = FALSE
  )
  out <- add_shooter_biometrics(play_by_play)
  testthat::expect_equal(out$shooterHeight, 72L)
  testthat::expect_equal(out$shooterWeight, 190L)
  testthat::expect_equal(out$shooterHandCode, 'L')
  testthat::expect_equal(out$shooterAge, 25L)
  testthat::expect_equal(out$shooterPositionCode, 'C')
  testthat::expect_false('shooterSide' %in% names(out))
})

# Run biometrics tests.
testthat::test_that('add_goalie_biometrics() leaves missing blocked-shot goalies as NA', {
  testthat::local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = 30L,
        height = 74L,
        weight = 185L,
        handCode = 'R',
        birthDate = '1998-01-01',
        stringsAsFactors = FALSE
      )
    },
    games = function() {
      data.frame(
        gameId = 1L,
        gameDate = '2025-01-10',
        stringsAsFactors = FALSE
      )
    },
    .package = 'nhlscraper'
  )
  play_by_play <- data.frame(
    gameId = c(1L, 1L),
    eventTypeDescKey = c('blocked-shot', 'blocked-shot'),
    goaliePlayerIdAgainst = c(NA_integer_, 30L),
    stringsAsFactors = FALSE
  )
  out <- add_goalie_biometrics(play_by_play)
  testthat::expect_true(all(is.na(out$goalieHeight[1])))
  testthat::expect_true(all(is.na(out$goalieWeight[1])))
  testthat::expect_true(all(is.na(out$goalieHandCode[1])))
  testthat::expect_true(all(is.na(out$goalieAge[1])))
  testthat::expect_equal(out$goalieHeight[2], 74L)
  testthat::expect_equal(out$goalieWeight[2], 185L)
  testthat::expect_equal(out$goalieHandCode[2], 'R')
  testthat::expect_equal(out$goalieAge[2], 27L)
  testthat::expect_false('goalieSide' %in% names(out))
})

# Run biometrics tests.
testthat::test_that('biometrics helpers respect game dates on aggregated inputs', {
  testthat::local_mocked_bindings(
    players = function() {
      data.frame(
        playerId = c(10L, 30L),
        height = c(72L, 74L),
        weight = c(190L, 185L),
        handCode = c('L', 'R'),
        positionCode = c('C', NA_character_),
        birthDate = c('2000-01-01', '1998-01-01'),
        stringsAsFactors = FALSE
      )
    },
    games = function() {
      data.frame(
        gameId = c(1L, 2L),
        gameDate = c('2025-01-10', '2026-01-10'),
        stringsAsFactors = FALSE
      )
    },
    .package = 'nhlscraper'
  )
  shooter_pbp <- data.frame(
    gameId = c(1L, 2L),
    scoringPlayerId = c(NA_integer_, NA_integer_),
    shootingPlayerId = c(10L, 10L),
    stringsAsFactors = FALSE
  )
  goalie_pbp <- data.frame(
    gameId = c(1L, 2L),
    goalieInNetId = c(30L, 30L),
    goaliePlayerIdAgainst = c(31L, 31L),
    stringsAsFactors = FALSE
  )
  shooter_out <- add_shooter_biometrics(shooter_pbp)
  goalie_out <- add_goalie_biometrics(goalie_pbp)
  testthat::expect_equal(shooter_out$shooterAge, c(25L, 26L))
  testthat::expect_equal(goalie_out$goalieAge, c(27L, 28L))
  testthat::expect_equal(shooter_out$shooterHeight, c(72L, 72L))
  testthat::expect_equal(goalie_out$goalieHeight, c(74L, 74L))
})
