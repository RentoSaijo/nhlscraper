# Tests ---------------------------------------------------------

testthat::test_that('shift_chart_summaries() loads the stored shift chart summary parquet', {
  src <- tempfile(fileext = '.parquet')
  summaries <- data.frame(
    gameId = 202120220001,
    teamId = 1L,
    teamTriCode = 'CAR',
    playerId = 8478402L,
    periodNumber = 1L,
    shifts = 8L,
    timeOnIce = 423L,
    evTimeOnIce = 301L,
    ppTimeOnIce = 82L,
    shTimeOnIce = 40L,
    stringsAsFactors = FALSE
  )
  arrow::write_parquet(summaries, src)
  testthat::local_mocked_bindings(
    download.file = function(url, destfile, mode = 'wb', quiet = TRUE, ...) {
      testthat::expect_true(grepl('data/game/scss/NHL_SCSS_20212022\\.parquet$', url))
      testthat::expect_true(file.copy(src, destfile, overwrite = TRUE))
      0L
    },
    .package = 'utils'
  )
  out <- shift_chart_summaries(20212022)
  testthat::expect_s3_class(out, 'data.frame')
  testthat::expect_named(out, names(summaries))
  testthat::expect_equal(out$gameId, summaries$gameId)
  testthat::expect_equal(out$timeOnIce, summaries$timeOnIce)
})
