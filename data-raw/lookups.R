# Read data.
NHL_Teams <- read.csv(
  'data-raw/NHL_Teams_19171918_20252026.csv',
  stringsAsFactors = FALSE
)

# Define helper.
normalize_key <- function(x) {
  x <- as.character(x)
  x <- tolower(trimws(x))
  x <- gsub('[^a-z0-9]', '', x)
  x
}

# Define base vectors.
tri_codes <- toupper(NHL_Teams$triCode)
ids       <- as.character(NHL_Teams$id)

## ------------------------------------------------------------------
## Lookup 1: any key -> tri-code  (.to_team_tri_code)
## ------------------------------------------------------------------

keys_tri <- c(
  normalize_key(NHL_Teams$id),
  normalize_key(NHL_Teams$triCode),
  normalize_key(NHL_Teams$fullName)
)
values_tri <- rep(tri_codes, times = 3)
.to_team_tri_code <- setNames(values_tri, keys_tri)

## ------------------------------------------------------------------
## Lookup 2: any key -> id  (.to_team_id)
## ------------------------------------------------------------------

keys_id <- c(
  normalize_key(NHL_Teams$id),
  normalize_key(NHL_Teams$triCode),
  normalize_key(NHL_Teams$fullName)
)
values_id <- rep(ids, times = 3)
.to_team_id <- setNames(values_id, keys_id)

# Save both objects into sysdata.rda.
save(list = c('.to_team_tri_code', '.to_team_id'), file = 'R/sysdata.rda')
