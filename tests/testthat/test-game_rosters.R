# Tests ---------------------------------------------------------

testthat::test_that('game_roster() returns a game-keyed data.frame', {
  testthat::skip_if_offline()
  test <- game_roster()
  testthat::expect_true(is.data.frame(test) && nrow(test) > 0)
  testthat::expect_identical(names(test)[[1]], 'gameId')
  testthat::expect_true(all(test$gameId == 2023030417L))
})

# Run game roster argument test.
testthat::test_that('game_roster(0) returns message and empty data.frame', {
  testthat::skip_if_offline()
  testthat::expect_message(
    test <- game_roster(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  testthat::expect_true(is.data.frame(test) && nrow(test) == 0)
})

# Run season game rosters test.
testthat::test_that('game_rosters() loads the stored season parquet', {
  rosters <- data.frame(
    gameId = 2021020001L,
    teamId = 1L,
    playerId = 8478402L,
    stringsAsFactors = FALSE
  )
  testthat::local_mocked_bindings(
    .read_remote_parquet = function(path) {
      testthat::expect_equal(
        path,
        'data/game/rosters/NHL_ROSTERS_20212022.parquet'
      )
      rosters
    },
    .package = 'nhlscraper'
  )
  testthat::expect_identical(game_rosters(20212022), rosters)
})
