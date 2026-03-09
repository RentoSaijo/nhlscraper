example_path <- function(...) {
  root <- normalizePath(file.path(testthat::test_path(), '..', '..'))
  file.path(root, ...)
}

mock_players <- function() {
  utils::read.csv(example_path('example_players.csv'), stringsAsFactors = FALSE)
}

count_goalies <- function(x) {
  vapply(
    x,
    FUN.VALUE = integer(1),
    function(v) {
      if (length(v) == 1L && is.na(v[1L])) 0L else length(v)
    }
  )
}

test_that("add_on_ice_players matches on-ice counts on the example sample", {
  testthat::local_mocked_bindings(players = mock_players, .package = 'nhlscraper')
  pbp <- utils::read.csv(example_path('example_gc_pbps.csv'), stringsAsFactors = FALSE)
  sc <- utils::read.csv(example_path('example_shift_charts.csv'), stringsAsFactors = FALSE)

  res <- add_on_ice_players(pbp, sc)
  target <- pbp$typeDescKey %in% c(
    'faceoff', 'hit', 'shot-on-goal', 'giveaway', 'missed-shot',
    'blocked-shot', 'penalty', 'goal', 'delayed-penalty',
    'takeaway', 'failed-shot-attempt'
  )
  home_goalie_target <- ifelse(pbp$homeIsEmptyNet, 0L, 1L)
  away_goalie_target <- ifelse(pbp$awayIsEmptyNet, 0L, 1L)

  expect_equal(lengths(res$homeSkaterPlayerIds[target]), pbp$homeSkaterCount[target])
  expect_equal(lengths(res$awaySkaterPlayerIds[target]), pbp$awaySkaterCount[target])
  expect_equal(count_goalies(res$homeGoaliePlayerId[target]), home_goalie_target[target])
  expect_equal(count_goalies(res$awayGoaliePlayerId[target]), away_goalie_target[target])
})

test_that("add_on_ice_players handles faceoffs and special rows on the example sample", {
  testthat::local_mocked_bindings(players = mock_players, .package = 'nhlscraper')
  pbp <- utils::read.csv(example_path('example_gc_pbps.csv'), stringsAsFactors = FALSE)
  sc <- utils::read.csv(example_path('example_shift_charts.csv'), stringsAsFactors = FALSE)

  regular <- add_on_ice_players(
    pbp[pbp$gameId == 2024020001L, ],
    sc[sc$gameId == 2024020001L, ]
  )
  faceoff <- regular[regular$eventId == 151L, ]
  shot <- regular[regular$eventId == 103L, ]

  expect_equal(faceoff$homeGoaliePlayerId[[1]], 8480045L)
  expect_equal(faceoff$awayGoaliePlayerId[[1]], 8474593L)
  expect_true(8478043L %in% faceoff$homeSkaterPlayerIds[[1]])
  expect_true(8480002L %in% faceoff$awaySkaterPlayerIds[[1]])
  expect_equal(shot$secondsElapsedInShiftFor[[1]], rep(8, 6))
  expect_equal(shot$secondsElapsedInShiftAgainst[[1]], rep(8, 6))

  shootout <- add_on_ice_players(
    pbp[pbp$gameId == 2024020022L, ],
    sc[sc$gameId == 2024020022L, ]
  )
  special <- shootout[shootout$eventId == 505L, ]

  expect_equal(special$homeSkaterPlayerIds[[1]], 8476468L)
  expect_equal(special$awayGoaliePlayerId[[1]], 8481035L)
  expect_true(length(special$awaySkaterPlayerIds[[1]]) == 0L)
  expect_true(is.na(special$homeSecondsElapsedInShift[[1]]))
  expect_true(is.na(special$awaySecondsElapsedInShift[[1]]))
})

test_that("add_on_ice_players defaults call gc_pbp() and shift_chart()", {
  pbp <- utils::read.csv(example_path('example_gc_pbps.csv'), stringsAsFactors = FALSE)
  sc <- utils::read.csv(example_path('example_shift_charts.csv'), stringsAsFactors = FALSE)
  game_pbp <- pbp[pbp$gameId == 2024020001L, ]
  game_sc <- sc[sc$gameId == 2024020001L, ]

  testthat::local_mocked_bindings(
    players = mock_players,
    gc_pbp = function() game_pbp,
    shift_chart = function() game_sc,
    .package = 'nhlscraper'
  )

  out <- add_on_ice_players()

  expect_equal(nrow(out), nrow(game_pbp))
  expect_equal(out$eventId[1], game_pbp$eventId[1])
  expect_equal(out$homeGoaliePlayerId[[2]], 8480045L)
})
