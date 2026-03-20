script_dir <- dirname(normalizePath(sub("^--file=", "", commandArgs(trailingOnly = FALSE)[grepl("^--file=", commandArgs(trailingOnly = FALSE))][1]), winslash = "/", mustWork = TRUE))
source(file.path(dirname(script_dir), "common.R"))

available_seasons <- list_source_seasons(script_dir, "gc")
seasons <- parse_season_args(commandArgs(trailingOnly = TRUE), available_seasons)
run_pbp_audit(
  source = "gc",
  seasons = seasons,
  source_dir = script_dir
)
