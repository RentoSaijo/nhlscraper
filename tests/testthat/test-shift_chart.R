test_that("shift_chart() returns non-empty data.frame", {
  skip_if_offline()
  test <- shift_chart()
  expect_true(is.data.frame(test) && nrow(test) > 0)
})

test_that("shift_chart(0) returns message and empty data.frame", {
  skip_if_offline()
  expect_message(
    test <- shift_chart(0),
    'Invalid argument\\(s\\); refer to help file\\.'
  )
  expect_true(is.data.frame(test) && nrow(test) == 0)
})

test_that("shift_chart() anchors overtime shifts to game time", {
  local_mocked_bindings(
    nhl_api = function(path, query = NULL, type = NULL) {
      expect_equal(path, "en/shiftcharts")
      game <- as.integer(sub("^gameId = ", "", query$cayenneExp))
      list(data = data.frame(
        id = 1:2,
        gameId = game,
        teamId = c(10L, 10L),
        playerId = c(101L, 101L),
        shiftNumber = c(1L, 2L),
        period = c(1L, 4L),
        startTime = c("00:10", "00:05"),
        endTime = c("00:20", "00:15"),
        eventDescription = c(NA_character_, NA_character_),
        stringsAsFactors = FALSE
      ))
    },
    .package = "nhlscraper"
  )

  reg <- shift_chart(2024020001)
  expect_equal(reg$startSecondsElapsedInGame, c(10L, 3605L))
  expect_equal(reg$endSecondsElapsedInGame, c(20L, 3615L))

  playoff <- shift_chart(2024030001)
  expect_equal(playoff$startSecondsElapsedInGame, c(10L, 3605L))
  expect_equal(playoff$endSecondsElapsedInGame, c(20L, 3615L))
})
