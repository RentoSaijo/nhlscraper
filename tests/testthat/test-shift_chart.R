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
    .perform_parallel_requests = function(...) stop("HTML unavailable"),
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

test_that("shift_chart() prefers API shifts when the API returns rows", {
  html_calls <- 0L

  local_mocked_bindings(
    .perform_parallel_requests = function(...) {
      html_calls <<- html_calls + 1L
      stop("HTML should not be called")
    },
    nhl_api = function(path, query = NULL, type = NULL) {
      expect_equal(path, "en/shiftcharts")
      game <- as.integer(sub("^gameId = ", "", query$cayenneExp))
      list(data = data.frame(
        id = 1L,
        gameId = game,
        teamId = 10L,
        playerId = 101L,
        shiftNumber = 1L,
        period = 1L,
        startTime = "00:10",
        endTime = "00:20",
        eventDescription = NA_character_,
        stringsAsFactors = FALSE
      ))
    },
    .package = "nhlscraper"
  )

  out <- shift_chart(2024020001)

  expect_equal(html_calls, 0L)
  expect_equal(nrow(out), 1L)
  expect_equal(out$playerId, 101L)
})

test_that("shift_chart() falls back to HTML when the API shift feed is empty", {
  home_html <- paste(
    "<table>",
    "<tr><td>10 DOE, JOHN</td></tr>",
    "<tr><td>1</td><td>1</td><td>00:00 / ON</td><td>00:20 / OFF</td><td></td><td></td></tr>",
    "</table>"
  )
  away_html <- paste(
    "<table>",
    "<tr><td>20 SMITH, JANE</td></tr>",
    "<tr><td>1</td><td>1</td><td>00:05 / ON</td><td>00:25 / OFF</td><td></td><td></td></tr>",
    "</table>"
  )

  local_mocked_bindings(
    nhl_api = function(path, query = NULL, type = NULL) {
      expect_equal(path, "en/shiftcharts")
      list(data = data.frame(
        id = integer(),
        gameId = integer(),
        teamId = integer(),
        playerId = integer(),
        shiftNumber = integer(),
        period = integer(),
        startTime = character(),
        endTime = character(),
        eventDescription = character(),
        stringsAsFactors = FALSE
      ))
    },
    .perform_parallel_requests = function(reqs, on_error = "return") {
      expect_named(reqs, c("pbp_meta", "home_report", "away_report"))
      list(
        pbp_meta = structure(list(kind = "pbp_meta"), class = "mock_resp"),
        home_report = httr2::response(body = charToRaw(home_html)),
        away_report = httr2::response(body = charToRaw(away_html))
      )
    },
    .parallel_request_failed = function(resp) FALSE,
    .nhl_json_from_response = function(resp) {
      expect_identical(resp$kind, "pbp_meta")
      list(
        rosterSpots = data.frame(
          teamId = c(1L, 2L),
          sweaterNumber = c("10", "20"),
          playerId = c(101L, 201L),
          lastName.default = c("Doe", "Smith"),
          firstName.default = c("John", "Jane"),
          stringsAsFactors = FALSE
        ),
        homeTeam = list(id = 1L),
        awayTeam = list(id = 2L)
      )
    },
    .package = "nhlscraper"
  )

  out <- shift_chart(2024020001)

  expect_equal(nrow(out), 2L)
  expect_equal(out$playerId, c(101L, 201L))
  expect_equal(out$startSecondsElapsedInPeriod, c(0L, 5L))
  expect_equal(out$endSecondsElapsedInPeriod, c(20L, 25L))
})
