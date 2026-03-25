test_that("xG ridge partitioning covers the six shot situations", {
  shots <- data.frame(
    situationCode = c("1551", "1441", "1541", "1451", "0650", "1010"),
    isEmptyNetFor = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    isEmptyNetAgainst = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE),
    skaterCountFor = c(5L, 4L, 5L, 4L, 6L, 1L),
    skaterCountAgainst = c(5L, 4L, 4L, 5L, 5L, 1L),
    stringsAsFactors = FALSE
  )

  expect_equal(
    nhlscraper:::.xg_partition_shots(shots),
    c("sd", "ev", "pp", "sh", "en", "ps")
  )
})

test_that("xG ridge partitioning routes uncategorizable rows to sd", {
  shots <- data.frame(
    situationCode = c(NA_character_, "1551", "1541", "1551"),
    isEmptyNetFor = c(FALSE, FALSE, FALSE, FALSE),
    isEmptyNetAgainst = c(FALSE, FALSE, FALSE, FALSE),
    skaterCountFor = c(NA_integer_, 5L, 4L, "oops"),
    skaterCountAgainst = c(NA_integer_, 5L, NA_integer_, 5L),
    stringsAsFactors = FALSE
  )

  expect_equal(
    nhlscraper:::.xg_partition_shots(shots),
    c("sd", "sd", "sd", "sd")
  )
})

test_that("xG ridge partitioning does not force sd on missing situationCode alone", {
  shots <- data.frame(
    situationCode = c(NA_character_, NA_character_),
    isEmptyNetFor = c(FALSE, FALSE),
    isEmptyNetAgainst = c(FALSE, FALSE),
    skaterCountFor = c(5L, 4L),
    skaterCountAgainst = c(4L, 4L),
    stringsAsFactors = FALSE
  )

  expect_equal(
    nhlscraper:::.xg_partition_shots(shots),
    c("pp", "ev")
  )
})

test_that("xG scorer rejects legacy alias-only public columns", {
  play_by_play <- data.frame(
    gameId = 1L,
    eventId = 1L,
    sortOrder = 1L,
    gameTypeId = 2L,
    period = 1L,
    eventOwnerTeamId = 1L,
    typeDescKey = "shot-on-goal",
    situationCode = "1551",
    stringsAsFactors = FALSE
  )

  expect_error(
    nhlscraper:::.xg_require_current_public_schema(play_by_play),
    "requires the current public play-by-play schema"
  )
})

test_that("xG categorical encoding keeps known baseline levels out of new bucket", {
  spec <- nhlscraper:::XG_RIDGE_MODEL_SPECS$sd

  encoded <- nhlscraper:::.xg_encode_categorical(
    values = c("backhand", "wrist", "mystery", NA),
    var = "shotType",
    spec = spec,
    n = 4L
  )

  expect_equal(encoded, c("backhand", "wrist", "new", "unknown"))
})

test_that("xG partition scoring returns finite probabilities with sparse inputs", {
  spec <- nhlscraper:::XG_RIDGE_MODEL_SPECS$ps
  df <- data.frame(
    shotType = c("backhand", "snap"),
    shooterHandCode = c("L", "R"),
    shooterPositionCode = c("C", "D"),
    goalieHandCode = c("L", "R"),
    isPlayoff = c(FALSE, TRUE),
    isHome = c(TRUE, FALSE),
    xCoordNorm = c(75, 78),
    yCoordNorm = c(0, 3),
    distance = c(13, 11),
    angle = c(12, 18),
    goalsFor = c(3, 4),
    goalsAgainst = c(3, 2),
    goalDifferential = c(0, 2),
    shotsFor = c(31, 34),
    shotsAgainst = c(32, 29),
    shotDifferential = c(-1, 5),
    fenwickFor = c(46, 50),
    fenwickAgainst = c(46, 44),
    fenwickDifferential = c(0, 6),
    corsiFor = c(64, 69),
    corsiAgainst = c(64, 61),
    corsiDifferential = c(0, 8),
    shooterHeight = c(73, 72),
    shooterWeight = c(198, 190),
    shooterAge = c(27, 25),
    goalieHeight = c(75, 74),
    goalieWeight = c(201, 198),
    goalieAge = c(28, 29),
    stringsAsFactors = FALSE
  )

  probs <- nhlscraper:::.xg_score_partition(df, spec)

  expect_length(probs, 2L)
  expect_true(all(is.finite(probs)))
  expect_true(all(probs > 0 & probs < 1))
})

test_that("xG scorer prefers goalieInNetId over goaliePlayerIdAgainst", {
  play_by_play <- data.frame(
    eventTypeDescKey = "shot-on-goal",
    periodNumber = 1L,
    shotsFor = 10L,
    shotsAgainst = 8L,
    shotDifferential = 2L,
    goaliePlayerIdAgainst = c(66L, NA_integer_),
    goalieInNetId = c(77L, 88L),
    stringsAsFactors = FALSE
  )

  out <- nhlscraper:::.xg_fill_goalie_against_fallback(play_by_play)

  expect_equal(out$goaliePlayerIdAgainst, c(77L, 88L))
})
