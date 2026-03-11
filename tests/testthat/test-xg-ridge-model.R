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
    c("sd", "ev", "pp", "sh", "en", "so")
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
  spec <- nhlscraper:::XG_RIDGE_MODEL_SPECS$so
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
