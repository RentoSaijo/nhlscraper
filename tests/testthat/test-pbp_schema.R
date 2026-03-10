test_that("gc_play_by_play() returns the public schema and fills goal shooters", {
  gc_raw <- data.frame(
    eventId = 1:3,
    timeInPeriod = c("00:10", "00:20", "00:30"),
    timeRemaining = c("19:50", "19:40", "19:30"),
    situationCode = c("1551", "1551", "1551"),
    homeTeamDefendingSide = c("left", "left", "left"),
    typeCode = c(502L, 505L, 506L),
    typeDescKey = c("faceoff", "goal", "shot-on-goal"),
    sortOrder = 1:3,
    pptReplayUrl = c(NA_character_, "https://example.com/ppt", NA_character_),
    periodDescriptor.number = c(1L, 1L, 1L),
    periodDescriptor.periodType = c("REG", "REG", "REG"),
    periodDescriptor.maxRegulationPeriods = c(3L, 3L, 3L),
    details.eventOwnerTeamId = c(10L, 10L, 20L),
    details.winningPlayerId = c(11L, NA_integer_, NA_integer_),
    details.losingPlayerId = c(21L, NA_integer_, NA_integer_),
    details.xCoord = c(0, 60, -55),
    details.yCoord = c(0, 10, -8),
    details.zoneCode = c("N", "O", "O"),
    details.shootingPlayerId = c(NA_integer_, NA_integer_, 99L),
    details.reason = c(NA_character_, "wrist", "snap"),
    details.shotType = c(NA_character_, "wrist", "snap"),
    details.goalieInNetId = c(NA_integer_, 30L, 40L),
    details.awaySOG = c(0L, 0L, 1L),
    details.homeSOG = c(0L, 1L, 1L),
    details.typeCode = c(NA_integer_, NA_integer_, NA_integer_),
    details.descKey = c(NA_character_, NA_character_, NA_character_),
    details.duration = c(NA_integer_, NA_integer_, NA_integer_),
    details.committedByPlayerId = c(NA_integer_, NA_integer_, NA_integer_),
    details.drawnByPlayerId = c(NA_integer_, NA_integer_, NA_integer_),
    details.scoringPlayerId = c(NA_integer_, 88L, NA_integer_),
    details.scoringPlayerTotal = c(NA_integer_, 1L, NA_integer_),
    details.assist1PlayerId = c(NA_integer_, 77L, NA_integer_),
    details.assist1PlayerTotal = c(NA_integer_, 1L, NA_integer_),
    details.assist2PlayerId = c(NA_integer_, 66L, NA_integer_),
    details.assist2PlayerTotal = c(NA_integer_, 1L, NA_integer_),
    details.awayScore = c(0L, 0L, 0L),
    details.homeScore = c(0L, 1L, 1L),
    details.highlightClipSharingUrl = c(NA_character_, "https://example.com/share", NA_character_),
    details.highlightClipSharingUrlFr = c(NA_character_, NA_character_, NA_character_),
    details.highlightClip = c(NA_character_, "https://example.com/highlight", NA_character_),
    details.highlightClipFr = c(NA_character_, NA_character_, NA_character_),
    details.discreteClip = c(NA_character_, "https://example.com/discrete", NA_character_),
    details.discreteClipFr = c(NA_character_, NA_character_, NA_character_),
    stringsAsFactors = FALSE
  )

  local_mocked_bindings(
    .perform_parallel_requests = function(reqs, on_error = "return") {
      expect_named(reqs, c("pbp_meta", "html_pbp"))
      list(
        pbp_meta = structure(list(kind = "pbp_meta"), class = "mock_resp"),
        html_pbp = structure(list(kind = "html_pbp"), class = "mock_resp")
      )
    },
    .parallel_request_failed = function(resp) FALSE,
    .nhl_json_from_response = function(resp) {
      if (identical(resp$kind, "pbp_meta")) {
        return(list(
          plays = gc_raw,
          rosterSpots = data.frame(),
          homeTeam = list(id = 10L, abbrev = "HOM"),
          awayTeam = list(id = 20L, abbrev = "AWY")
        ))
      }
      stop("Unexpected response kind")
    },
    .optional_html_pbp_rows_from_response = function(...) data.frame(),
    .add_html_on_ice_players = function(play_by_play, ...) {
      play_by_play <- .add_empty_html_on_ice_columns(play_by_play)
      play_by_play$homeGoaliePlayerId <- c(NA_integer_, 30L, 40L)
      play_by_play$awayGoaliePlayerId <- c(NA_integer_, 50L, 60L)
      play_by_play$goaliePlayerIdFor <- c(NA_integer_, 30L, 60L)
      play_by_play$goaliePlayerIdAgainst <- c(NA_integer_, 50L, 40L)
      play_by_play$homeSkater1PlayerId <- c(NA_integer_, 101L, 102L)
      play_by_play$awaySkater1PlayerId <- c(NA_integer_, 201L, 202L)
      play_by_play$skater1PlayerIdFor <- c(NA_integer_, 101L, 202L)
      play_by_play$skater1PlayerIdAgainst <- c(NA_integer_, 201L, 102L)
      play_by_play$homeSkater6PlayerId <- c(NA_integer_, 106L, NA_integer_)
      play_by_play$awaySkater6PlayerId <- c(NA_integer_, NA_integer_, 206L)
      play_by_play$skater6PlayerIdFor <- c(NA_integer_, 106L, 206L)
      play_by_play$skater6PlayerIdAgainst <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$homeSkater7PlayerId <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$awaySkater7PlayerId <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$skater7PlayerIdFor <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$skater7PlayerIdAgainst <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$homeSkater8PlayerId <- c(NA_integer_, 108L, NA_integer_)
      play_by_play$awaySkater8PlayerId <- c(NA_integer_, NA_integer_, 208L)
      play_by_play$skater8PlayerIdFor <- c(NA_integer_, 108L, 208L)
      play_by_play$skater8PlayerIdAgainst <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play
    },
    .add_on_ice_shift_timing_context = function(...) stop(".add_on_ice_shift_timing_context() should not be called"),
    .package = "nhlscraper"
  )

  out <- gc_play_by_play(2010020001)

  expect_false(any(c(
    "period", "typeCode", "typeDescKey", "homeSOG", "awaySOG", "SOGFor",
    "SOGAgainst", "SOGDifferential", "descKey", "duration", "timeInPeriod",
    "timeRemaining", "awayScore", "homeScore", "goalieInNetId"
  ) %in% names(out)))
  expect_true(all(c(
    "periodNumber", "periodType", "eventTypeCode", "eventTypeDescKey",
    "homeShots", "awayShots", "shotsFor", "shotsAgainst", "shotDifferential",
    "penaltyTypeDescKey", "penaltyDuration", "pptReplayUrl",
    "homeGoaliePlayerId", "awayGoaliePlayerId", "goaliePlayerIdFor",
    "goaliePlayerIdAgainst", "homeSkater1PlayerId", "awaySkater1PlayerId",
    "skater1PlayerIdFor", "skater1PlayerIdAgainst", "homeSkater6PlayerId",
    "awaySkater6PlayerId", "skater6PlayerIdFor", "skater6PlayerIdAgainst",
    "homeSkater7PlayerId", "awaySkater7PlayerId", "skater7PlayerIdFor",
    "skater7PlayerIdAgainst", "homeSkater8PlayerId", "awaySkater8PlayerId",
    "skater8PlayerIdFor", "skater8PlayerIdAgainst"
  ) %in% names(out)))
  strength_idx <- match("strengthState", names(out))
  expect_equal(
    names(out)[(strength_idx + 1L):(strength_idx + 4L)],
    c(
      "homeGoaliePlayerId",
      "awayGoaliePlayerId",
      "goaliePlayerIdFor",
      "goaliePlayerIdAgainst"
    )
  )
  expect_equal(
    out$shootingPlayerId[out$eventTypeDescKey == "goal"],
    out$scoringPlayerId[out$eventTypeDescKey == "goal"]
  )
  expect_true(all(c("playerId", "blockingPlayerId", "servedByPlayerId") %in% names(out)))
  expect_true(all(is.na(out$playerId)))
  expect_true(all(is.na(out$blockingPlayerId)))
  expect_true(all(is.na(out$servedByPlayerId)))
  expect_false("homeGoalieSecondsElapsedInShift" %in% names(out))
  expect_false("homeGoalieSecondsElapsedInPeriodSinceLastShift" %in% names(out))
  expect_equal(
    names(out)[match("drawnByPlayerId", names(out)) + 1L],
    "servedByPlayerId"
  )
})

test_that("wsc_play_by_play() returns the public schema with utc and no clip fields", {
  wsc_raw <- data.frame(
    id = 999L,
    eventId = 1:3,
    period = c(1L, 1L, 1L),
    timeInPeriod = c("00:10", "00:20", "00:30"),
    secondsRemaining = c(1190L, 1180L, 1170L),
    situationCode = c("1551", "1551", "1551"),
    typeCode = c(502L, 505L, 506L),
    typeDescKey = c("faceoff", "goal", "shot-on-goal"),
    homeTeamDefendingSide = c("left", "left", "left"),
    sortOrder = 1:3,
    utc = c(
      "2010-10-07T00:00:10Z",
      "2010-10-07T00:00:20Z",
      "2010-10-07T00:00:30Z"
    ),
    eventOwnerTeamId = c(10L, 10L, 20L),
    losingPlayerId = c(21L, NA_integer_, NA_integer_),
    winningPlayerId = c(11L, NA_integer_, NA_integer_),
    xCoord = c(0, 60, -55),
    yCoord = c(0, 10, -8),
    zoneCode = c("N", "O", "O"),
    shootingPlayerId = c(NA_integer_, NA_integer_, 99L),
    reason = c(NA_character_, "wrist", "snap"),
    shotType = c(NA_character_, "wrist", "snap"),
    goalieInNetId = c(NA_integer_, 30L, 40L),
    awaySOG = c(0L, 0L, 1L),
    homeSOG = c(0L, 1L, 1L),
    penaltyTypeCode = c(NA_integer_, NA_integer_, NA_integer_),
    descKey = c(NA_character_, NA_character_, NA_character_),
    duration = c(NA_integer_, NA_integer_, NA_integer_),
    committedByPlayerId = c(NA_integer_, NA_integer_, NA_integer_),
    drawnByPlayerId = c(NA_integer_, NA_integer_, NA_integer_),
    strength = c(NA_character_, NA_character_, NA_character_),
    strengthCode = c(NA_character_, NA_character_, NA_character_),
    goalCode = c(NA_character_, NA_character_, NA_character_),
    scoringPlayerId = c(NA_integer_, 88L, NA_integer_),
    assist1PlayerId = c(NA_integer_, 77L, NA_integer_),
    assist2PlayerId = c(NA_integer_, 66L, NA_integer_),
    awayScore = c(0L, 0L, 0L),
    homeScore = c(0L, 1L, 1L),
    scoringPlayerTotal = c(NA_integer_, 1L, NA_integer_),
    assist1PlayerTotal = c(NA_integer_, 1L, NA_integer_),
    assist2PlayerTotal = c(NA_integer_, 1L, NA_integer_),
    stringsAsFactors = FALSE
  )

  local_mocked_bindings(
    .perform_parallel_requests = function(reqs, on_error = "return") {
      expect_named(reqs, c("pbp_meta", "wsc", "html_pbp"))
      list(
        pbp_meta = structure(list(kind = "pbp_meta"), class = "mock_resp"),
        wsc = structure(list(kind = "wsc"), class = "mock_resp"),
        html_pbp = structure(list(kind = "html_pbp"), class = "mock_resp")
      )
    },
    .parallel_request_failed = function(resp) FALSE,
    .nhl_json_from_response = function(resp) {
      if (identical(resp$kind, "pbp_meta")) {
        return(list(
          rosterSpots = data.frame(),
          homeTeam = list(id = 10L, abbrev = "HOM"),
          awayTeam = list(id = 20L, abbrev = "AWY")
        ))
      }
      if (identical(resp$kind, "wsc")) {
        return(wsc_raw)
      }
      stop("Unexpected response kind")
    },
    .optional_html_pbp_rows_from_response = function(...) data.frame(),
    .add_html_on_ice_players = function(play_by_play, ...) {
      play_by_play <- .add_empty_html_on_ice_columns(play_by_play)
      play_by_play$homeGoaliePlayerId <- c(NA_integer_, 30L, 40L)
      play_by_play$awayGoaliePlayerId <- c(NA_integer_, 50L, 60L)
      play_by_play$goaliePlayerIdFor <- c(NA_integer_, 30L, 60L)
      play_by_play$goaliePlayerIdAgainst <- c(NA_integer_, 50L, 40L)
      play_by_play$homeSkater1PlayerId <- c(NA_integer_, 101L, 102L)
      play_by_play$awaySkater1PlayerId <- c(NA_integer_, 201L, 202L)
      play_by_play$skater1PlayerIdFor <- c(NA_integer_, 101L, 202L)
      play_by_play$skater1PlayerIdAgainst <- c(NA_integer_, 201L, 102L)
      play_by_play$homeSkater6PlayerId <- c(NA_integer_, 106L, NA_integer_)
      play_by_play$awaySkater6PlayerId <- c(NA_integer_, NA_integer_, 206L)
      play_by_play$skater6PlayerIdFor <- c(NA_integer_, 106L, 206L)
      play_by_play$skater6PlayerIdAgainst <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$homeSkater7PlayerId <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$awaySkater7PlayerId <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$skater7PlayerIdFor <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$skater7PlayerIdAgainst <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play$homeSkater8PlayerId <- c(NA_integer_, 108L, NA_integer_)
      play_by_play$awaySkater8PlayerId <- c(NA_integer_, NA_integer_, 208L)
      play_by_play$skater8PlayerIdFor <- c(NA_integer_, 108L, 208L)
      play_by_play$skater8PlayerIdAgainst <- c(NA_integer_, NA_integer_, NA_integer_)
      play_by_play
    },
    .add_on_ice_shift_timing_context = function(...) stop(".add_on_ice_shift_timing_context() should not be called"),
    .package = "nhlscraper"
  )

  out <- wsc_play_by_play(2010020001)

  expect_false(any(c(
    "period", "typeCode", "typeDescKey", "homeSOG", "awaySOG", "SOGFor",
    "SOGAgainst", "SOGDifferential", "descKey", "duration", "timeInPeriod",
    "secondsRemaining", "awayScore", "homeScore", "periodType",
    "discreteClip", "highlightClip", "highlightClipSharingUrl", "pptReplayUrl",
    "goalieInNetId"
  ) %in% names(out)))
  expect_true(all(c(
    "periodNumber", "utc", "eventTypeCode", "eventTypeDescKey", "homeShots",
    "awayShots", "shotsFor", "shotsAgainst", "shotDifferential",
    "penaltyTypeDescKey", "penaltyDuration", "homeGoaliePlayerId",
    "awayGoaliePlayerId", "goaliePlayerIdFor", "goaliePlayerIdAgainst",
    "homeSkater1PlayerId", "awaySkater1PlayerId", "skater1PlayerIdFor",
    "skater1PlayerIdAgainst", "homeSkater6PlayerId", "awaySkater6PlayerId",
    "skater6PlayerIdFor", "skater6PlayerIdAgainst", "homeSkater7PlayerId",
    "awaySkater7PlayerId", "skater7PlayerIdFor", "skater7PlayerIdAgainst",
    "homeSkater8PlayerId", "awaySkater8PlayerId", "skater8PlayerIdFor",
    "skater8PlayerIdAgainst"
  ) %in% names(out)))
  expect_match(names(out)[10], "^utc$")
  strength_idx <- match("strengthState", names(out))
  expect_equal(
    names(out)[(strength_idx + 1L):(strength_idx + 4L)],
    c(
      "homeGoaliePlayerId",
      "awayGoaliePlayerId",
      "goaliePlayerIdFor",
      "goaliePlayerIdAgainst"
    )
  )
  expect_equal(
    out$shootingPlayerId[out$eventTypeDescKey == "goal"],
    out$scoringPlayerId[out$eventTypeDescKey == "goal"]
  )
  expect_true(all(c("playerId", "blockingPlayerId", "servedByPlayerId") %in% names(out)))
  expect_true(all(is.na(out$playerId)))
  expect_true(all(is.na(out$blockingPlayerId)))
  expect_true(all(is.na(out$servedByPlayerId)))
  expect_false("homeGoalieSecondsElapsedInShift" %in% names(out))
  expect_false("homeGoalieSecondsElapsedInPeriodSinceLastShift" %in% names(out))
  expect_equal(
    names(out)[match("drawnByPlayerId", names(out)) + 1L],
    "servedByPlayerId"
  )
})

test_that("illogically ordered boundary faceoffs are removed", {
  pbp <- data.frame(
    gameId = rep(1L, 5L),
    eventId = c(10L, 11L, 12L, 13L, 14L),
    sortOrder = c(190L, 201L, 206L, 209L, 211L),
    period = c(1L, 1L, 1L, 2L, 2L),
    timeInPeriod = c("18:24", "20:00", "00:00", "00:00", "00:00"),
    typeDescKey = c("shot-on-goal", "period-end", "faceoff", "period-start", "faceoff"),
    stringsAsFactors = FALSE
  )

  out <- pbp |>
    .strip_game_id() |>
    .strip_time_period() |>
    .drop_illogical_ordered_events()

  expect_false(12L %in% out$eventId)
  expect_equal(out$eventId, c(10L, 11L, 13L, 14L))
})
