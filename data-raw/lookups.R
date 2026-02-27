# Read data.
NHL_Teams <- read.csv(
  'data-raw/NHL_Teams_19171918_20252026.csv',
  stringsAsFactors = FALSE
)

required_cols <- c('teamId', 'teamTriCode', 'teamFullName')
missing_cols <- required_cols[!required_cols %in% names(NHL_Teams)]
if (length(missing_cols)) {
  stop(
    'Missing required team column(s): ',
    paste(missing_cols, collapse = ', ')
  )
}

# Define helper.
normalize_key <- function(x) {
  x <- as.character(x)
  x <- tolower(trimws(x))
  x <- gsub('[^a-z0-9]', '', x)
  x
}

# Define base vectors.
tri_codes <- toupper(NHL_Teams$teamTriCode)
ids       <- as.character(NHL_Teams$teamId)

## ------------------------------------------------------------------
## Lookup 1: any key -> tri-code  (.to_team_tri_code)
## ------------------------------------------------------------------

key_blocks_tri <- list(
  normalize_key(NHL_Teams$teamId),
  normalize_key(NHL_Teams$teamTriCode),
  normalize_key(NHL_Teams$teamFullName)
)
if ('teamTriCodeRaw' %in% names(NHL_Teams)) {
  key_blocks_tri <- append(key_blocks_tri, list(normalize_key(NHL_Teams$teamTriCodeRaw)))
}
keys_tri <- unlist(key_blocks_tri, use.names = FALSE)
values_tri <- rep(tri_codes, times = length(key_blocks_tri))
.to_team_tri_code <- setNames(values_tri, keys_tri)

## ------------------------------------------------------------------
## Lookup 2: any key -> id  (.to_team_id)
## ------------------------------------------------------------------

key_blocks_id <- list(
  normalize_key(NHL_Teams$teamId),
  normalize_key(NHL_Teams$teamTriCode),
  normalize_key(NHL_Teams$teamFullName)
)
if ('teamTriCodeRaw' %in% names(NHL_Teams)) {
  key_blocks_id <- append(key_blocks_id, list(normalize_key(NHL_Teams$teamTriCodeRaw)))
}
keys_id <- unlist(key_blocks_id, use.names = FALSE)
values_id <- rep(ids, times = length(key_blocks_id))
.to_team_id <- setNames(values_id, keys_id)

# Save objects into sysdata.rda while preserving existing internal objects.
save_env <- new.env(parent = emptyenv())
if (file.exists('R/sysdata.rda')) {
  load('R/sysdata.rda', envir = save_env)
}
assign('.to_team_tri_code', .to_team_tri_code, envir = save_env)
assign('.to_team_id', .to_team_id, envir = save_env)
save(
  list = ls(save_env, all.names = TRUE),
  file = 'R/sysdata.rda',
  envir = save_env,
  compress = 'xz'
)
