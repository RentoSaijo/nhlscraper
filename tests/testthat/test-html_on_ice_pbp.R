test_that("HTML PBP parser resolves on-ice players and owner perspective", {
  roster_lookup <- .build_game_roster_lookup(data.frame(
    teamId = c(8L, 8L, 8L, 10L, 10L, 10L),
    playerId = c(801L, 802L, 803L, 1001L, 1002L, 1003L),
    sweaterNumber = c(11L, 31L, 76L, 37L, 35L, 2L),
    positionCode = c("C", "G", "D", "C", "G", "D"),
    playerLastName = c("Gomez", "Price", "Subban", "Brent", "Giguere", "Schenn"),
    playerFirstName = c("Scott", "Carey", "P.K.", "Clarke", "Jean-Sebastien", "Luke"),
    stringsAsFactors = FALSE
  ))

  html <- paste(
    "<table>",
    "<tr><th>#</th><th>Per</th><th>Str</th><th>Time:ElapsedGame</th><th>Event</th><th>Description</th><th>MTL On Ice</th><th>TOR On Ice</th></tr>",
    "<tr><td>2</td><td>1</td><td>EV</td><td>0:0020:00</td><td>FAC</td><td>MTL won Neu. Zone - MTL #11 GOMEZ vs TOR #37 BRENT</td><td>11 C 76 D 31 G</td><td>37 C 2 D 35 G</td></tr>",
    "<tr><td>7</td><td>1</td><td>EV</td><td>1:1318:47</td><td>BLOCK</td><td>MTL #76 SUBBAN BLOCKED BY TOR #2 SCHENN, Wrist, Def. Zone</td><td>11 C 76 D 31 G</td><td>37 C 2 D 35 G</td></tr>",
    "<tr><td>82</td><td>1</td><td>EV</td><td>14:025:58</td><td>PENL</td><td>MTL #81 ELLER Hooking(2 min), Def. Zone Drawn By: TOR #37 BRENT</td><td>11 C 76 D 31 G</td><td>37 C 2 D 35 G</td></tr>",
    "</table>"
  )
  doc <- xml2::read_html(html)
  out <- .parse_html_pbp_doc(
    doc = doc,
    roster_lookup = roster_lookup,
    home_team_id = 10L,
    away_team_id = 8L,
    home_abbrev = "TOR",
    away_abbrev = "MTL",
    is_playoffs = FALSE
  )

  expect_equal(out$typeDescKey, c("faceoff", "blocked-shot", "penalty"))
  expect_equal(out$ownerTeamId, c(8L, 8L, 8L))
  expect_equal(out$primaryPlayerId[1], 801L)
  expect_equal(out$secondaryPlayerId[1], 1001L)
  expect_equal(out$primaryPlayerId[2], 803L)
  expect_equal(out$secondaryPlayerId[2], 1003L)
  expect_equal(out$homeGoaliePlayerId, c(1002L, 1002L, 1002L))
  expect_equal(out$awayGoaliePlayerId, c(802L, 802L, 802L))
  expect_equal(out$homeSkaterPlayerIds[[1]], c(1001L, 1003L))
  expect_equal(out$awaySkaterPlayerIds[[1]], c(801L, 803L))
})

test_that("HTML PBP parser preserves six-skater empty-net rows", {
  roster_lookup <- .build_game_roster_lookup(data.frame(
    teamId = c(rep(8L, 6L), rep(10L, 7L)),
    playerId = c(801:806, 1001:1007),
    sweaterNumber = c(11L, 12L, 13L, 14L, 15L, 16L, 31L, 32L, 33L, 34L, 35L, 36L, 37L),
    positionCode = c(rep("F", 6L), "G", rep("F", 6L)),
    playerLastName = paste0("P", c(801:806, 1001:1007)),
    playerFirstName = "A",
    stringsAsFactors = FALSE
  ))

  html <- paste(
    "<table>",
    "<tr><th>#</th><th>Per</th><th>Str</th><th>Time:ElapsedGame</th><th>Event</th><th>Description</th><th>MTL On Ice</th><th>TOR On Ice</th></tr>",
    "<tr><td>301</td><td>3</td><td>6v5</td><td>19:100:50</td><td>SHOT</td><td>TOR ONGOAL - #32 P1002, Wrist, Off. Zone, 20 ft.</td><td>11 F 12 F 13 F 14 F 15 F 16 F</td><td>31 G 32 F 33 F 34 F 35 F 36 F 37 F</td></tr>",
    "</table>"
  )
  doc <- xml2::read_html(html)
  out <- .parse_html_pbp_doc(
    doc = doc,
    roster_lookup = roster_lookup,
    home_team_id = 10L,
    away_team_id = 8L,
    home_abbrev = "TOR",
    away_abbrev = "MTL",
    is_playoffs = FALSE
  )

  expect_true(is.na(out$awayGoaliePlayerId[1]))
  expect_equal(out$awaySkaterPlayerIds[[1]], 801:806)
  expect_equal(out$homeGoaliePlayerId[1], 1001L)
  expect_equal(out$homeSkaterPlayerIds[[1]], 1002:1007)
})

test_that("HTML PBP parser handles dotted team abbreviations", {
  roster_lookup <- .build_game_roster_lookup(data.frame(
    teamId = c(28L, 28L, 22L, 22L),
    playerId = c(2801L, 2802L, 2201L, 2202L),
    sweaterNumber = c(19L, 31L, 93L, 40L),
    positionCode = c("C", "G", "C", "G"),
    playerLastName = c("Thornton", "Niemi", "Nugent-Hopkins", "Dubnyk"),
    playerFirstName = c("Joe", "Antti", "Ryan", "Devan"),
    stringsAsFactors = FALSE
  ))

  html <- paste(
    "<table>",
    "<tr><th>#</th><th>Per</th><th>Str</th><th>Time:ElapsedGame</th><th>Event</th><th>Description</th><th>S.J On Ice</th><th>EDM On Ice</th></tr>",
    "<tr><td>2</td><td>1</td><td>EV</td><td>0:0020:00</td><td>FAC</td><td>S.J won Neu. Zone - EDM #93 NUGENT-HOPKINS vs S.J #19 THORNTON</td><td>19 C 31 G</td><td>93 C 40 G</td></tr>",
    "</table>"
  )
  doc <- xml2::read_html(html)
  out <- .parse_html_pbp_doc(
    doc = doc,
    roster_lookup = roster_lookup,
    home_team_id = 22L,
    away_team_id = 28L,
    home_abbrev = "EDM",
    away_abbrev = "SJS",
    is_playoffs = FALSE
  )

  expect_equal(out$typeDescKey, "faceoff")
  expect_equal(out$ownerTeamId, 28L)
  expect_equal(out$homeGoaliePlayerId, 2202L)
  expect_equal(out$awayGoaliePlayerId, 2802L)
})

test_that("HTML PBP matcher aligns events when same-second rows differ locally", {
  play_by_play <- data.frame(
    gameId = rep(2010020001L, 3L),
    eventId = c(10L, 11L, 12L),
    period = c(1L, 1L, 1L),
    secondsElapsedInPeriod = c(100L, 100L, 101L),
    sortOrder = c(10L, 11L, 12L),
    typeDescKey = c("blocked-shot", "penalty", "faceoff"),
    eventOwnerTeamId = c(8L, 8L, 10L),
    isHome = c(FALSE, FALSE, TRUE),
    situationCode = c("1551", "1551", "1451"),
    shootingPlayerId = c(803L, NA_integer_, NA_integer_),
    blockingPlayerId = c(1003L, NA_integer_, NA_integer_),
    committedByPlayerId = c(NA_integer_, 803L, NA_integer_),
    drawnByPlayerId = c(NA_integer_, 1001L, NA_integer_),
    winningPlayerId = c(NA_integer_, NA_integer_, 1001L),
    losingPlayerId = c(NA_integer_, NA_integer_, 801L),
    playerId = c(NA_integer_, NA_integer_, NA_integer_),
    stringsAsFactors = FALSE
  )
  html_rows <- data.frame(
    htmlEventNumber = c(50L, 51L, 52L),
    period = c(1L, 1L, 1L),
    strengthCodeHtml = c("EV", "EV", "PP"),
    secondsElapsedInPeriod = c(100L, 100L, 101L),
    htmlEventCode = c("BLOCK", "PENL", "FAC"),
    typeDescKey = c("blocked-shot", "penalty", "faceoff"),
    description = c(
      "MTL #76 SUBBAN BLOCKED BY TOR #2 SCHENN",
      "MTL #76 SUBBAN Hooking(2 min), Drawn By: TOR #37 BRENT",
      "TOR won Neu. Zone - TOR #37 BRENT vs MTL #11 GOMEZ"
    ),
    ownerTeamId = c(8L, 8L, 10L),
    primaryPlayerId = c(803L, 803L, 1001L),
    secondaryPlayerId = c(1003L, 1001L, 801L),
    tertiaryPlayerId = c(NA_integer_, NA_integer_, NA_integer_),
    homeGoaliePlayerId = c(1002L, 1002L, 1002L),
    awayGoaliePlayerId = c(802L, 802L, 802L),
    stringsAsFactors = FALSE
  )
  html_rows$homeSkaterPlayerIds <- list(c(1001L, 1003L), c(1001L, 1003L), c(1001L, 1003L))
  html_rows$awaySkaterPlayerIds <- list(c(801L, 803L), c(801L, 803L), c(801L, 803L))

  matched <- .match_html_pbp_to_api(play_by_play, html_rows)

  expect_equal(matched$apiIndex, c(1L, 2L, 3L))
})

test_that("HTML PBP matcher rescues duplicate shot clusters after greedy backtracking", {
  filler_n <- 26L
  n <- filler_n + 4L

  play_by_play <- data.frame(
    gameId = rep(2015020150L, n),
    eventId = seq_len(n),
    period = c(3L, rep(1L, filler_n), 3L, 3L, 3L),
    secondsElapsedInPeriod = c(765L, seq_len(filler_n), 766L, 765L, 766L),
    sortOrder = seq_len(n),
    typeDescKey = c("shot-on-goal", rep("faceoff", filler_n), "shot-on-goal", "shot-on-goal", "shot-on-goal"),
    eventOwnerTeamId = c(6L, rep(10L, filler_n), 6L, 6L, 6L),
    isHome = c(FALSE, rep(TRUE, filler_n), FALSE, FALSE, FALSE),
    situationCode = rep("1551", n),
    shootingPlayerId = c(8474625L, rep(NA_integer_, filler_n), 8474625L, 8474625L, 8474625L),
    blockingPlayerId = rep(NA_integer_, n),
    committedByPlayerId = rep(NA_integer_, n),
    drawnByPlayerId = rep(NA_integer_, n),
    winningPlayerId = c(NA_integer_, 1001L + seq_len(filler_n) - 1L, NA_integer_, NA_integer_, NA_integer_),
    losingPlayerId = c(NA_integer_, 2001L + seq_len(filler_n) - 1L, NA_integer_, NA_integer_, NA_integer_),
    playerId = rep(NA_integer_, n),
    stringsAsFactors = FALSE
  )

  html_rows <- data.frame(
    htmlEventNumber = seq_len(n),
    period = c(rep(1L, filler_n), 3L, 3L, 3L, 3L),
    strengthCodeHtml = rep("EV", n),
    secondsElapsedInPeriod = c(seq_len(filler_n), 765L, 765L, 766L, 766L),
    htmlEventCode = c(rep("FAC", filler_n), rep("SHOT", 4L)),
    typeDescKey = c(rep("faceoff", filler_n), rep("shot-on-goal", 4L)),
    description = "",
    ownerTeamId = c(rep(10L, filler_n), rep(6L, 4L)),
    primaryPlayerId = c(1001L + seq_len(filler_n) - 1L, rep(8474625L, 4L)),
    secondaryPlayerId = c(2001L + seq_len(filler_n) - 1L, rep(NA_integer_, 4L)),
    tertiaryPlayerId = rep(NA_integer_, n),
    homeGoaliePlayerId = rep(10L, n),
    awayGoaliePlayerId = rep(20L, n),
    stringsAsFactors = FALSE
  )
  html_rows$homeSkaterPlayerIds <- rep(list(101:105), n)
  html_rows$awaySkaterPlayerIds <- rep(list(201:205), n)

  matched <- .match_html_pbp_to_api(play_by_play, html_rows)

  expect_equal(nrow(matched), n)
  shot_api_idx <- matched$apiIndex[match((filler_n + 1L):n, matched$htmlEventNumber)]
  expect_equal(shot_api_idx[1:2], c(29L, 1L))
  expect_equal(sort(shot_api_idx), c(1L, 28L, 29L, 30L))
})

test_that("HTML PBP matcher does not discard candidates when API actors are NA", {
  play_by_play <- data.frame(
    gameId = c(1L, 1L),
    eventId = c(10L, 11L),
    period = c(2L, 2L),
    secondsElapsedInPeriod = c(1167L, 1167L),
    sortOrder = c(10L, 11L),
    typeDescKey = c("penalty", "penalty"),
    eventOwnerTeamId = c(9L, 9L),
    isHome = c(FALSE, FALSE),
    situationCode = c("1551", "1551"),
    committedByPlayerId = c(8476999L, 8482092L),
    drawnByPlayerId = c(NA_integer_, 8480796L),
    playerId = c(NA_integer_, NA_integer_),
    stringsAsFactors = FALSE
  )
  html_rows <- data.frame(
    htmlEventNumber = c(218L, 222L),
    period = c(2L, 2L),
    strengthCodeHtml = c("EV", "EV"),
    secondsElapsedInPeriod = c(1167L, 1167L),
    htmlEventCode = c("PENL", "PENL"),
    typeDescKey = c("penalty", "penalty"),
    description = c(
      "OTT #35 ULLMARK Goalie leave crease(2 min) Served By: #21 COUSINS, Off. Zone",
      "OTT #71 GREIG Roughing(2 min), Off. Zone Drawn By: WSH #42 FEHERVARY"
    ),
    ownerTeamId = c(9L, 9L),
    primaryPlayerId = c(8476999L, 8482092L),
    secondaryPlayerId = c(8481656L, 8480796L),
    tertiaryPlayerId = c(NA_integer_, NA_integer_),
    homeGoaliePlayerId = c(1L, 1L),
    awayGoaliePlayerId = c(2L, 2L),
    stringsAsFactors = FALSE
  )
  html_rows$homeSkaterPlayerIds <- list(c(101L, 102L, 103L, 104L, 105L), c(101L, 102L, 103L, 104L, 105L))
  html_rows$awaySkaterPlayerIds <- list(c(201L, 202L, 203L, 204L, 205L), c(201L, 202L, 203L, 204L, 205L))

  matched <- .match_html_pbp_to_api(play_by_play, html_rows)

  expect_equal(matched$apiIndex[match(c(218L, 222L), matched$htmlEventNumber)], c(1L, 2L))
})

test_that("shift timing context populates scalar goalie and skater timing columns", {
  play_by_play <- data.frame(
    gameId = c(1L, 1L),
    periodNumber = c(1L, 1L),
    secondsElapsedInPeriod = c(40L, 80L),
    eventTypeDescKey = c("shot-on-goal", "hit"),
    isHome = c(TRUE, FALSE),
    homeGoaliePlayerId = c(101L, 101L),
    awayGoaliePlayerId = c(201L, 201L),
    homeSkater1PlayerId = c(111L, 111L),
    awaySkater1PlayerId = c(211L, 211L),
    homeSkater2PlayerId = c(NA_integer_, NA_integer_),
    awaySkater2PlayerId = c(NA_integer_, NA_integer_),
    homeSkater3PlayerId = c(NA_integer_, NA_integer_),
    awaySkater3PlayerId = c(NA_integer_, NA_integer_),
    homeSkater4PlayerId = c(NA_integer_, NA_integer_),
    awaySkater4PlayerId = c(NA_integer_, NA_integer_),
    homeSkater5PlayerId = c(NA_integer_, NA_integer_),
    awaySkater5PlayerId = c(NA_integer_, NA_integer_),
    homeSkater6PlayerId = c(NA_integer_, NA_integer_),
    awaySkater6PlayerId = c(NA_integer_, NA_integer_),
    stringsAsFactors = FALSE
  )
  shift_data <- data.frame(
    gameId = c(1L, 1L, 1L, 1L, 1L, 1L),
    teamId = c(1L, 1L, 1L, 2L, 2L, 2L),
    playerId = c(101L, 111L, 111L, 201L, 211L, 211L),
    period = c(1L, 1L, 1L, 1L, 1L, 1L),
    startSecondsElapsedInPeriod = c(0L, 0L, 70L, 0L, 0L, 70L),
    endSecondsElapsedInPeriod = c(120L, 50L, 120L, 120L, 60L, 120L),
    stringsAsFactors = FALSE
  )

  out <- .add_on_ice_shift_timing_context(play_by_play, game = 1L, shift_data = shift_data)

  expect_equal(out$homeGoalieSecondsElapsedInShift, c(40, 80))
  expect_equal(out$awayGoalieSecondsElapsedInShift, c(40, 80))
  expect_equal(out$homeSkater1SecondsElapsedInShift, c(40, 10))
  expect_equal(out$awaySkater1SecondsElapsedInShift, c(40, 10))
  expect_equal(out$homeSkater1SecondsElapsedInPeriodSinceLastShift, c(340, 30))
  expect_equal(out$awaySkater1SecondsElapsedInPeriodSinceLastShift, c(340, 20))
  expect_equal(out$goalieSecondsElapsedInShiftFor, c(40, 80))
  expect_equal(out$goalieSecondsElapsedInShiftAgainst, c(40, 80))
  expect_equal(out$skater1SecondsElapsedInShiftFor, c(40, 10))
  expect_equal(out$skater1SecondsElapsedInShiftAgainst, c(40, 10))
})

test_that("public helpers require the new public schema names", {
  legacy_speed <- data.frame(
    gameId = 1L,
    eventId = 1L,
    sortOrder = 1L,
    secondsElapsedInGame = 1L,
    typeDescKey = "shot-on-goal",
    situationCode = "1551",
    xCoordNorm = 0,
    yCoordNorm = 0,
    distance = 10,
    angle = 0,
    stringsAsFactors = FALSE
  )
  expect_error(add_deltas(legacy_speed), "eventTypeDescKey")

  legacy_goalie <- data.frame(
    gameId = 1L,
    goalieInNetId = 99L,
    stringsAsFactors = FALSE
  )
  expect_error(add_goalie_biometrics(legacy_goalie), "goaliePlayerIdAgainst")
})

test_that("goalie biometrics use goaliePlayerIdAgainst", {
  play_by_play <- data.frame(
    gameId = 1L,
    goaliePlayerIdAgainst = 99L,
    stringsAsFactors = FALSE
  )
  local_mocked_bindings(
    players = function() data.frame(
      playerId = 99L,
      height = 74L,
      weight = 190L,
      handCode = "L",
      birthDate = "1990-01-15",
      stringsAsFactors = FALSE
    ),
    games = function() data.frame(
      gameId = 1L,
      gameDate = "2020-02-01",
      stringsAsFactors = FALSE
    ),
    .package = "nhlscraper"
  )

  out <- add_goalie_biometrics(play_by_play)
  expect_equal(out$goalieHeight, 74L)
  expect_equal(out$goalieWeight, 190L)
  expect_equal(out$goalieHandCode, "L")
  expect_equal(out$goalieAge, 30L)
})
