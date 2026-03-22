test_that("gc_play_by_plays_raw() returns the stored raw parquet without padding situationCode", {
  src <- tempfile(fileext = ".parquet")
  raw_pbp <- data.frame(
    gameId = 202120220001,
    eventId = 1L,
    situationCode = "651",
    stringsAsFactors = FALSE
  )
  arrow::write_parquet(raw_pbp, src)

  local_mocked_bindings(
    download.file = function(url, destfile, mode = "wb", quiet = TRUE, ...) {
      expect_true(grepl("NHL_PBPS_GC_(Raw_)?20212022\\.parquet$", url))
      expect_true(file.copy(src, destfile, overwrite = TRUE))
      0L
    },
    .package = "utils"
  )

  raw_out <- gc_play_by_plays_raw(20212022)
  clean_out <- gc_play_by_plays(20212022)

  expect_equal(raw_out$situationCode, "651")
  expect_equal(clean_out$situationCode, "0651")
})

test_that("wsc_play_by_plays_raw() returns the stored raw parquet without padding situationCode", {
  src <- tempfile(fileext = ".parquet")
  raw_pbp <- data.frame(
    gameId = 202120220001,
    eventId = 1L,
    situationCode = "551",
    stringsAsFactors = FALSE
  )
  arrow::write_parquet(raw_pbp, src)

  local_mocked_bindings(
    download.file = function(url, destfile, mode = "wb", quiet = TRUE, ...) {
      expect_true(grepl("NHL_PBPS_WSC_(Raw_)?20212022\\.parquet$", url))
      expect_true(file.copy(src, destfile, overwrite = TRUE))
      0L
    },
    .package = "utils"
  )

  raw_out <- wsc_play_by_plays_raw(20212022)
  clean_out <- wsc_play_by_plays(20212022)

  expect_equal(raw_out$situationCode, "551")
  expect_equal(clean_out$situationCode, "0551")
})
