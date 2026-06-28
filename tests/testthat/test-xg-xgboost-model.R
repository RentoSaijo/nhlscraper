# Tests ---------------------------------------------------------

# Clear xG model cache.
.clear_xg_model_cache <- function() {
  rm(
    list = ls(envir = nhlscraper:::.xg_model_cache),
    envir = nhlscraper:::.xg_model_cache
  )
}

# Fake xg bundle.
.fake_xg_bundle <- function(
  model_key,
  path,
  built_at = 'unit-test',
  sha = paste(rep('0', 64), collapse = '')
) {
  parts <- strsplit(model_key, '_', fixed = TRUE)[[1L]]
  model_index <- data.frame(
    vintage = parts[[1L]],
    targetSeason = as.integer(sub('^v', '', parts[[1L]])),
    partition = parts[[2L]],
    boosterPath = path,
    boosterSha256 = sha,
    stringsAsFactors = FALSE
  )
  list(
    model_index = model_index,
    partition_specs = parts[[2L]],
    preprocess_specs = list(),
    metadata = list(),
    built_at = built_at
  )
}

# Run xg-xgboost-model tests.
testthat::test_that('xG partitioning covers the six shot situations', {
  shots <- data.frame(
    situationCode = c('1551', '1441', '1541', '1451', '0650', '1010'),
    isEmptyNetFor = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    isEmptyNetAgainst = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE),
    skaterCountFor = c(5L, 4L, 5L, 4L, 6L, 1L),
    skaterCountAgainst = c(5L, 4L, 4L, 5L, 5L, 1L),
    stringsAsFactors = FALSE
  )
  testthat::expect_equal(
    nhlscraper:::.xg_partition_shots(shots),
    c('sd', 'ev', 'pp', 'sh', 'en', 'ps')
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG partitioning routes uncategorizable rows to sd', {
  shots <- data.frame(
    situationCode = c(NA_character_, '1551', '1541', '1551'),
    isEmptyNetFor = c(FALSE, FALSE, FALSE, FALSE),
    isEmptyNetAgainst = c(FALSE, FALSE, FALSE, FALSE),
    skaterCountFor = c(NA_integer_, 5L, 4L, 'oops'),
    skaterCountAgainst = c(NA_integer_, 5L, NA_integer_, 5L),
    stringsAsFactors = FALSE
  )
  testthat::expect_equal(
    nhlscraper:::.xg_partition_shots(shots),
    c('sd', 'sd', 'sd', 'sd')
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG partitioning does not force sd on missing situationCode alone', {
  shots <- data.frame(
    situationCode = c(NA_character_, NA_character_),
    isEmptyNetFor = c(FALSE, FALSE),
    isEmptyNetAgainst = c(FALSE, FALSE),
    skaterCountFor = c(5L, 4L),
    skaterCountAgainst = c(4L, 4L),
    stringsAsFactors = FALSE
  )
  testthat::expect_equal(
    nhlscraper:::.xg_partition_shots(shots),
    c('pp', 'ev')
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG scorer rejects legacy alias-only public columns', {
  play_by_play <- data.frame(
    gameId = 1L,
    eventId = 1L,
    sortOrder = 1L,
    gameTypeId = 2L,
    period = 1L,
    eventOwnerTeamId = 1L,
    typeDescKey = 'shot-on-goal',
    situationCode = '1551',
    stringsAsFactors = FALSE
  )
  testthat::expect_error(
    nhlscraper:::.xg_require_current_public_schema(play_by_play),
    'requires the current public play-by-play schema'
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG target-season selection uses bundled vintages', {
  bundle <- nhlscraper:::.xg_load_bundle()
  testthat::expect_equal(
    nhlscraper:::.xg_select_target_season(
      c(2011020001, 2024020001, 2026020001, NA),
      bundle
    ),
    c(20132014L, 20242025L, 20262027L, 20262027L)
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster URLs use the configurable NHLxG base URL', {
  old <- options(nhlscraper.xg_model_base_url = 'https://example.test/base/')
  on.exit(options(old), add = TRUE)
  testthat::expect_equal(
    nhlscraper:::.xg_booster_url('models/v20262027_ps.xgb'),
    'https://example.test/base/models/v20262027_ps.xgb'
  )
  testthat::expect_error(
    nhlscraper:::.xg_booster_url('models/v20262027_ps.ubj'),
    'Unsafe xG booster path'
  )
  options(nhlscraper.xg_model_base_url = 'http://example.test/base')
  testthat::expect_error(
    nhlscraper:::.xg_booster_url('models/v20262027_ps.xgb'),
    'must use HTTPS'
  )
  options(old)
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster loader downloads missing boosters into the cache', {
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  cache_dir <- tempfile('xg-cache-')
  src <- tempfile(fileext = '.xgb')
  writeBin(as.raw(1:4), src)
  src_sha <- unname(tools::sha256sum(src))
  old <- options(
    nhlscraper.xg_cache_dir = cache_dir,
    nhlscraper.xg_model_base_url = 'https://example.test/base',
    nhlscraper.xg_auto_download = TRUE
  )
  on.exit(options(old), add = TRUE)
  bundle <- .fake_xg_bundle(
    model_key = 'v99999999_ps',
    path = 'models/v99999999_ps.xgb',
    sha = src_sha
  )
  cached <- nhlscraper:::.xg_cached_booster_path(
    'models/v99999999_ps.xgb',
    bundle
  )
  testthat::local_mocked_bindings(
    download.file = function(url, destfile, mode = 'wb', quiet = TRUE, ...) {
      testthat::expect_equal(url, 'https://example.test/base/models/v99999999_ps.xgb')
      testthat::expect_equal(mode, 'wb')
      testthat::expect_true(quiet)
      testthat::expect_true(file.copy(src, destfile, overwrite = TRUE))
      0L
    },
    .package = 'utils'
  )
  testthat::local_mocked_bindings(
    xgb.load = function(path) {
      testthat::expect_equal(path, cached)
      list(path = path, size = file.info(path)$size)
    },
    .package = 'xgboost'
  )
  booster <- nhlscraper:::.xg_load_booster('v99999999_ps', bundle)
  testthat::expect_true(file.exists(cached))
  testthat::expect_equal(booster$path, cached)
  testthat::expect_equal(booster$size, 4)
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster loader reuses cached boosters without downloading', {
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  cache_dir <- tempfile('xg-cache-')
  old <- options(
    nhlscraper.xg_cache_dir = cache_dir,
    nhlscraper.xg_model_base_url = 'https://example.test/base',
    nhlscraper.xg_auto_download = TRUE
  )
  on.exit(options(old), add = TRUE)
  bundle <- .fake_xg_bundle(
    model_key = 'v88888888_ps',
    path = 'models/v88888888_ps.xgb',
    built_at = 'cache-test',
    sha = paste(rep('0', 64), collapse = '')
  )
  cached <- nhlscraper:::.xg_cached_booster_path(
    'models/v88888888_ps.xgb',
    bundle
  )
  dir.create(dirname(cached), recursive = TRUE, showWarnings = FALSE)
  writeBin(as.raw(5:8), cached)
  bundle$model_index$boosterSha256 <- unname(tools::sha256sum(cached))
  testthat::local_mocked_bindings(
    download.file = function(...) {
      stop('download.file should not be called')
    },
    .package = 'utils'
  )
  testthat::local_mocked_bindings(
    xgb.load = function(path) {
      testthat::expect_equal(path, cached)
      list(path = path)
    },
    .package = 'xgboost'
  )
  booster <- nhlscraper:::.xg_load_booster('v88888888_ps', bundle)
  testthat::expect_equal(booster$path, cached)
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster resolution rejects unsafe bundle paths', {
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  unsafe <- list(
    '/tmp/v77777777_ps.xgb',
    '../models/v77777777_ps.xgb',
    'results/v77777777_ps.xgb',
    'models/v77777777_ps.ubj',
    'models/../v77777777_ps.xgb'
  )
  for (path in unsafe) {
    bundle <- .fake_xg_bundle(
      model_key = 'v77777777_ps',
      path = path
    )
    testthat::expect_error(
      nhlscraper:::.xg_resolve_booster_path('v77777777_ps', bundle),
      'Unsafe xG booster path'
    )
  }
})

# Run xg-xgboost-model tests.
testthat::test_that('xG bundle validation rejects legacy artifact path columns', {
  bundle <- .fake_xg_bundle(
    model_key = 'v77777777_ps',
    path = 'models/v77777777_ps.xgb'
  )
  bundle$model_index$preprocessPath <- 'models/v77777777_ps_preprocess.rds'
  testthat::expect_error(
    nhlscraper:::.xg_validate_bundle(bundle),
    'unexpected path columns'
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster resolution respects disabled auto-downloads', {
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  old <- options(
    nhlscraper.xg_cache_dir = tempfile('xg-cache-'),
    nhlscraper.xg_auto_download = FALSE
  )
  on.exit(options(old), add = TRUE)
  bundle <- .fake_xg_bundle(
    model_key = 'v77777777_ps',
    path = 'models/v77777777_ps.xgb'
  )
  testthat::expect_error(
    nhlscraper:::.xg_resolve_booster_path('v77777777_ps', bundle),
    'xg_auto_download'
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster resolution reports failed downloads', {
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  old <- options(
    nhlscraper.xg_cache_dir = tempfile('xg-cache-'),
    nhlscraper.xg_model_base_url = 'https://example.test/base',
    nhlscraper.xg_auto_download = TRUE
  )
  on.exit(options(old), add = TRUE)
  bundle <- .fake_xg_bundle(
    model_key = 'v66666666_ps',
    path = 'models/v66666666_ps.xgb'
  )
  testthat::local_mocked_bindings(
    download.file = function(...) 1L,
    .package = 'utils'
  )
  testthat::expect_error(
    nhlscraper:::.xg_resolve_booster_path('v66666666_ps', bundle),
    'Failed to download xG booster'
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG booster resolution rejects checksum mismatches', {
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  cache_dir <- tempfile('xg-cache-')
  src <- tempfile(fileext = '.xgb')
  writeBin(as.raw(9:12), src)
  old <- options(
    nhlscraper.xg_cache_dir = cache_dir,
    nhlscraper.xg_model_base_url = 'https://example.test/base',
    nhlscraper.xg_auto_download = TRUE
  )
  on.exit(options(old), add = TRUE)
  bundle <- .fake_xg_bundle(
    model_key = 'v55555555_ps',
    path = 'models/v55555555_ps.xgb'
  )
  testthat::local_mocked_bindings(
    download.file = function(url, destfile, mode = 'wb', quiet = TRUE, ...) {
      testthat::expect_true(file.copy(src, destfile, overwrite = TRUE))
      0L
    },
    .package = 'utils'
  )
  testthat::expect_error(
    nhlscraper:::.xg_resolve_booster_path('v55555555_ps', bundle),
    'checksum verification'
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG categorical encoding keeps known levels out of new bucket', {
  spec <- nhlscraper:::.xg_load_bundle()$preprocess_specs$v20262027_sd
  encoded <- nhlscraper:::.xg_encode_categorical(
    values = c('backhand', 'wrist', 'mystery', NA),
    var = 'shotType',
    spec = spec,
    n = 4L
  )
  testthat::expect_equal(encoded, c('backhand', 'wrist', 'new', 'unknown'))
})

# Run xg-xgboost-model tests.
testthat::test_that('xG matrix baking follows frozen preprocessing spec', {
  spec <- nhlscraper:::.xg_load_bundle()$preprocess_specs$v20262027_sd
  mat <- nhlscraper:::.xg_bake_matrix(
    data.frame(
      shotType = c('wrist', 'mystery'),
      isHome = c(TRUE, FALSE),
      distance = c(12, NA),
      stringsAsFactors = FALSE
    ),
    spec
  )
  testthat::expect_equal(dim(mat), c(2L, length(spec$feature_names)))
  testthat::expect_equal(colnames(mat), spec$feature_names)
  testthat::expect_equal(unname(mat[, 'shotType_wrist']), c(1, 0))
  testthat::expect_equal(unname(mat[, 'shotType_new']), c(0, 1))
  testthat::expect_false(anyNA(mat))
})

# Run xg-xgboost-model tests.
testthat::test_that('xG XGBoost scoring returns finite probabilities with sparse inputs', {
  testthat::skip_on_cran()
  .clear_xg_model_cache()
  on.exit(.clear_xg_model_cache(), add = TRUE)
  old <- options(
    nhlscraper.xg_cache_dir = tempfile('xg-cache-'),
    nhlscraper.xg_auto_download = TRUE
  )
  on.exit(options(old), add = TRUE)
  df <- data.frame(
    shotType = c('backhand', 'snap'),
    shooterHandCode = c('L', 'R'),
    shooterPositionCode = c('C', 'D'),
    goalieHandCode = c('L', 'R'),
    isPlayoff = c(FALSE, TRUE),
    isHome = c(TRUE, FALSE),
    periodType = c('SO', 'SO'),
    periodNumber = c(5L, 5L),
    shootoutAttemptNumber = c(1L, 2L),
    shootoutGoalDifferential = c(0L, 1L),
    xCoordNorm = c(75, 78),
    yCoordNorm = c(0, 3),
    absYCoordNorm = c(0, 3),
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
  probs <- nhlscraper:::.xg_score_xgboost(df, 'v20262027_ps')
  testthat::expect_length(probs, 2L)
  testthat::expect_true(all(is.finite(probs)))
  testthat::expect_true(all(probs > 0 & probs < 1))
  testthat::expect_equal(
    probs,
    c(0.34944474697113037, 0.3137451708316803),
    tolerance = 1e-12
  )
})

# Run xg-xgboost-model tests.
testthat::test_that('xG scorer prefers goalieInNetId over goaliePlayerIdAgainst', {
  play_by_play <- data.frame(
    eventTypeDescKey = 'shot-on-goal',
    periodNumber = 1L,
    shotsFor = 10L,
    shotsAgainst = 8L,
    shotDifferential = 2L,
    goaliePlayerIdAgainst = c(66L, NA_integer_),
    goalieInNetId = c(77L, 88L),
    stringsAsFactors = FALSE
  )
  out <- nhlscraper:::.xg_fill_goalie_against_fallback(play_by_play)
  testthat::expect_equal(out$goaliePlayerIdAgainst, c(77L, 88L))
})
