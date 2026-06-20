test_that('calculate_shift_times_by_situation() splits exact strengths by player perspective', {
  play_by_play <- data.frame(
    gameId = rep(1L, 4L),
    periodNumber = rep(1L, 4L),
    secondsElapsedInPeriod = c(0L, 80L, 200L, 300L),
    sortOrder = seq_len(4L),
    eventOwnerTeamId = c(10L, 20L, 10L, 20L),
    isHome = c(TRUE, FALSE, TRUE, FALSE),
    situationCode = c('1551', '1451', '1541', '1551'),
    stringsAsFactors = FALSE
  )
  shift_data <- data.frame(
    gameId = rep(1L, 2L),
    teamId = c(10L, 20L),
    playerId = c(101L, 201L),
    shiftNumber = c(1L, 1L),
    periodNumber = c(1L, 1L),
    startSecondsElapsedInPeriod = c(0L, 0L),
    endSecondsElapsedInPeriod = c(300L, 300L),
    stringsAsFactors = FALSE
  )
  roster_data <- data.frame(
    teamId = c(10L, 20L),
    playerId = c(101L, 201L),
    playerFirstName = c('Home', 'Away'),
    playerLastName = c('Skater', 'Skater'),
    sweaterNumber = c(11L, 22L),
    positionCode = c('C', 'L'),
    stringsAsFactors = FALSE
  )
  local_mocked_bindings(
    gc_play_by_play = function(game) play_by_play,
    shift_chart = function(game) shift_data,
    game_rosters = function(game) roster_data,
    teams = function() {
      data.frame(
        teamId = c(10L, 20L),
        teamTriCode = c('HOM', 'AWY'),
        stringsAsFactors = FALSE
      )
    },
    .package = 'nhlscraper'
  )

  out <- calculate_shift_times_by_situation(game = 1L)
  home <- out[out$playerId == 101L, ]
  away <- out[out$playerId == 201L, ]

  expect_named(out, c(
    'gameId',
    'teamId',
    'teamTriCode',
    'playerId',
    'playerFirstName',
    'playerLastName',
    'sweaterNumber',
    'positionCode',
    'periodNumber',
    'shifts',
    'timeOnIce',
    '1551TimeOnIce',
    '1541TimeOnIce',
    '1451TimeOnIce'
  ))
  expect_equal(home[['timeOnIce']], 300L)
  expect_equal(home[['1551TimeOnIce']], 80L)
  expect_equal(home[['1541TimeOnIce']], 120L)
  expect_equal(home[['1451TimeOnIce']], 100L)
  expect_equal(away[['timeOnIce']], 300L)
  expect_equal(away[['1551TimeOnIce']], 80L)
  expect_equal(away[['1541TimeOnIce']], 100L)
  expect_equal(away[['1451TimeOnIce']], 120L)
  expect_equal(home[['teamTriCode']], 'HOM')
  expect_equal(away[['teamTriCode']], 'AWY')
})

test_that('calculate_shift_times_by_situation() uses season data when season is supplied', {
  play_by_play <- data.frame(
    gameId = rep(2L, 2L),
    periodNumber = rep(1L, 2L),
    secondsElapsedInPeriod = c(0L, 1200L),
    sortOrder = c(1L, 2L),
    eventOwnerTeamId = c(30L, 40L),
    isHome = c(TRUE, FALSE),
    situationCode = c('1551', '1551'),
    stringsAsFactors = FALSE
  )
  shift_data <- data.frame(
    gameId = 2L,
    teamId = 30L,
    playerId = 301L,
    periodNumber = 1L,
    startSecondsElapsedInPeriod = 0L,
    endSecondsElapsedInPeriod = 10L,
    stringsAsFactors = FALSE
  )
  local_mocked_bindings(
    gc_play_by_play = function(game) stop('game play-by-play should not be used'),
    shift_chart = function(game) stop('game shift chart should not be used'),
    gc_play_by_plays = function(season) {
      expect_equal(season, 20242025L)
      play_by_play
    },
    shift_charts = function(season) {
      expect_equal(season, 20242025L)
      shift_data
    },
    teams = function() {
      data.frame(
        teamId = c(30L, 40L),
        teamTriCode = c('HOM', 'AWY'),
        stringsAsFactors = FALSE
      )
    },
    players = function() {
      data.frame(
        playerId = 301L,
        playerFirstName = 'Season',
        playerLastName = 'Player',
        sweaterNumber = 31L,
        positionCode = 'D',
        stringsAsFactors = FALSE
      )
    },
    .package = 'nhlscraper'
  )

  out <- calculate_shift_times_by_situation(game = 0L, season = 20242025L)

  expect_equal(nrow(out), 1L)
  expect_equal(out[['gameId']], 2L)
  expect_equal(out[['teamTriCode']], 'HOM')
  expect_equal(out[['playerFirstName']], 'Season')
  expect_equal(out[['1551TimeOnIce']], 10L)
})
