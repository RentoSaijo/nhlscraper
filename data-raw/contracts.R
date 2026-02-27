# Build internal contracts data object (.contracts_base) for package runtime.
csv_paths <- sort(list.files(
  path = 'data-raw',
  pattern = '^NHL_Contracts_.*\\.csv$',
  full.names = TRUE
))
if (!length(csv_paths)) {
  stop("No contract CSV files found in 'data-raw' matching NHL_Contracts_*.csv")
}
normalize_key <- function(x) {
  x <- as.character(x)
  x <- tolower(trimws(x))
  gsub('[^a-z0-9]', '', x)
}
parse_money <- function(x) {
  x <- trimws(as.character(x))
  x <- gsub('[$,]', '', x)
  x[x == ''] <- NA_character_
  suppressWarnings(as.numeric(x))
}
parse_year <- function(x) {
  y <- gsub('[^0-9]', '', trimws(as.character(x)))
  y[y == ''] <- NA_character_
  y <- substr(y, 1L, 4L)
  suppressWarnings(as.integer(y))
}
to_season_id <- function(year_vec) {
  out <- rep(NA_integer_, length(year_vec))
  ok <- !is.na(year_vec)
  out[ok] <- year_vec[ok] * 10000L + (year_vec[ok] + 1L)
  out
}
canonicalize_team_tri_code <- function(x) {
  x <- toupper(trimws(as.character(x)))
  alias <- c(
    WAS = 'WSH'
  )
  idx <- match(x, names(alias))
  x[!is.na(idx)] <- unname(alias[idx[!is.na(idx)]])
  x
}
teams <- read.csv(
  'data-raw/NHL_Teams_19171918_20252026.csv',
  stringsAsFactors = FALSE
)
required_team_cols <- c('teamId', 'teamTriCode', 'teamFullName')
missing_team_cols <- required_team_cols[!required_team_cols %in% names(teams)]
if (length(missing_team_cols)) {
  stop(
    'Missing required team column(s): ',
    paste(missing_team_cols, collapse = ', ')
  )
}
team_key_blocks <- list(
  normalize_key(teams$teamId),
  normalize_key(teams$teamTriCode),
  normalize_key(teams$teamFullName)
)
if ('teamTriCodeRaw' %in% names(teams)) {
  team_key_blocks <- append(team_key_blocks, list(normalize_key(teams$teamTriCodeRaw)))
}
team_keys <- unlist(team_key_blocks, use.names = FALSE)
team_vals <- rep(as.character(teams$teamId), times = length(team_key_blocks))
.team_id_lookup <- setNames(team_vals, team_keys)
to_team_id_local <- function(team) {
  unname(.team_id_lookup[normalize_key(team)])
}
raw <- do.call(rbind, lapply(csv_paths, function(path) {
  d <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  d$sourceFile <- basename(path)
  d
}))
names(raw) <- trimws(gsub('[[:space:]]+', ' ', names(raw)))
raw <- raw[!(is.na(raw$Player) | trimws(raw$Player) == ''), , drop = FALSE]
team_signed <- trimws(gsub('[[:space:]]+', ' ', raw[['Team Signed With']]))
team_split <- strsplit(team_signed, ' ', fixed = TRUE)
team_tri <- toupper(vapply(
  team_split,
  function(x) if (length(x) >= 1L) x[[1]] else NA_character_,
  character(1)
))
signed_with_tri <- toupper(vapply(
  team_split,
  function(x) if (length(x) >= 2L) x[[2]] else NA_character_,
  character(1)
))
same_team <- is.na(signed_with_tri) | signed_with_tri == ''
signed_with_tri[same_team] <- team_tri[same_team]
team_tri <- canonicalize_team_tri_code(team_tri)
signed_with_tri <- canonicalize_team_tri_code(signed_with_tri)
start_year <- parse_year(raw$Start)
end_year <- parse_year(raw$End)
contract_years <- suppressWarnings(as.integer(trimws(as.character(raw$Yrs))))
missing_years <- is.na(contract_years) & !is.na(start_year) & !is.na(end_year)
contract_years[missing_years] <- end_year[missing_years] - start_year[missing_years] + 1L
invalid_end <- is.na(end_year) | (!is.na(start_year) & end_year < start_year)
can_fill_end <- invalid_end & !is.na(start_year) & !is.na(contract_years)
end_year[can_fill_end] <- start_year[can_fill_end] + contract_years[can_fill_end] - 1L
mismatch <- !is.na(start_year) & !is.na(end_year) & !is.na(contract_years) &
  (end_year - start_year + 1L != contract_years)
end_year[mismatch] <- start_year[mismatch] + contract_years[mismatch] - 1L
raw$playerFullName <- trimws(raw$Player)
raw$positionCode <- toupper(trimws(raw$Pos))
raw$positionCode[raw$positionCode == 'LW'] <- 'L'
raw$positionCode[raw$positionCode == 'RW'] <- 'R'
raw$teamTriCode <- team_tri
raw$teamId <- suppressWarnings(as.integer(to_team_id_local(raw$teamTriCode)))
raw$signedWithTriCode <- signed_with_tri
raw$signedWithTeamId <- suppressWarnings(as.integer(to_team_id_local(raw$signedWithTriCode)))
raw$ageAtSigning <- suppressWarnings(as.integer(trimws(as.character(raw[['Age At Signing']]))))
raw$startSeasonId <- to_season_id(start_year)
raw$endSeasonId <- to_season_id(end_year)
raw$contractYears <- contract_years
raw$contractValue <- parse_money(raw$Value)
raw$contractAAV <- parse_money(raw$AAV)
raw$signingBonus <- parse_money(raw[['Signing Bonus']])
raw$twoYearCash <- parse_money(raw[['2-Year Cash']])
raw$threeYearCash <- parse_money(raw[['3-Year Cash']])
out <- raw[, c(
  'playerFullName',
  'positionCode',
  'teamTriCode',
  'teamId',
  'signedWithTriCode',
  'signedWithTeamId',
  'ageAtSigning',
  'startSeasonId',
  'endSeasonId',
  'contractYears',
  'contractValue',
  'contractAAV',
  'signingBonus',
  'twoYearCash',
  'threeYearCash',
  'sourceFile'
)]
duplicate_key <- paste(
  out$playerFullName,
  out$positionCode,
  out$teamTriCode,
  out$signedWithTriCode,
  out$ageAtSigning,
  out$startSeasonId,
  out$endSeasonId,
  out$contractYears,
  out$contractValue,
  out$contractAAV,
  out$signingBonus,
  out$twoYearCash,
  out$threeYearCash,
  sep = '|'
)
duplicate_idx <- duplicated(duplicate_key)
dropped_duplicate_rows <- sum(duplicate_idx)
out <- out[!duplicate_idx, , drop = FALSE]
invalid_season <- is.na(out$startSeasonId) | is.na(out$endSeasonId)
dropped_invalid_season <- sum(invalid_season)
out <- out[!invalid_season, , drop = FALSE]
out <- out[order(out$startSeasonId, out$playerFullName), , drop = FALSE]
rownames(out) <- NULL
attr(out, 'droppedDuplicateRows') <- dropped_duplicate_rows
attr(out, 'droppedInvalidSeasonRows') <- dropped_invalid_season
save_env <- new.env(parent = emptyenv())
if (file.exists('R/sysdata.rda')) {
  load('R/sysdata.rda', envir = save_env)
}
assign('.contracts_base', out, envir = save_env)
save(
  list = ls(save_env, all.names = TRUE),
  file = 'R/sysdata.rda',
  envir = save_env,
  compress = 'xz'
)
message(
  sprintf(
    'Saved .contracts_base to R/sysdata.rda (%s rows; %s duplicate rows removed; %s invalid-season rows removed).',
    nrow(out),
    dropped_duplicate_rows,
    dropped_invalid_season
  )
)
