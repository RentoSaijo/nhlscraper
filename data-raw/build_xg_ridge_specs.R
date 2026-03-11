# Build frozen ridge xG specs for package runtime.
#
# Usage:
#   Rscript data-raw/build_xg_ridge_specs.R \
#     /path/to/models/xG/nhlscraper/results \
#     /path/to/models/xG/data

args <- commandArgs(trailingOnly = TRUE)

results_dir <- if (length(args) >= 1L) {
  args[[1L]]
} else {
  Sys.getenv("NHLSCRAPER_XG_RESULTS_DIR", unset = "")
}

train_dir <- if (length(args) >= 2L) {
  args[[2L]]
} else {
  Sys.getenv("NHLSCRAPER_XG_TRAIN_DIR", unset = "")
}

if (!nzchar(results_dir) || !dir.exists(results_dir)) {
  stop(
    "Provide a valid ridge results directory as argv[1] or NHLSCRAPER_XG_RESULTS_DIR.",
    call. = FALSE
  )
}

if (!nzchar(train_dir) || !dir.exists(train_dir)) {
  stop(
    "Provide a valid train-data directory as argv[2] or NHLSCRAPER_XG_TRAIN_DIR.",
    call. = FALSE
  )
}

partitions <- c("sd", "ev", "pp", "sh", "en", "so")
out_file <- file.path("R", "xg_ridge_specs.R")

read_named_numeric <- function(path, name_col, value_col) {
  dat <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  out <- as.numeric(dat[[value_col]])
  names(out) <- dat[[name_col]]
  out
}

read_named_pair <- function(path, name_col, value_cols) {
  dat <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  out <- setNames(vector("list", nrow(dat)), dat[[name_col]])
  for (i in seq_len(nrow(dat))) {
    out[[i]] <- as.list(dat[i, value_cols, drop = FALSE])
  }
  out
}

is_yes_no_column <- function(x) {
  if (is.logical(x)) {
    return(TRUE)
  }
  vals <- unique(as.character(x[!is.na(x)]))
  length(vals) > 0L && all(vals %in% c("TRUE", "FALSE", "T", "F", "0", "1"))
}

load_train_levels <- function(path, variables) {
  header <- names(
    read.csv(
      path,
      nrows = 0L,
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  )
  keep <- intersect(header, variables)
  if (!length(keep)) {
    return(list(levels = list(), logical_vars = character()))
  }

  col_classes <- rep("NULL", length(header))
  names(col_classes) <- header
  col_classes[keep] <- NA_character_

  dat <- read.csv(
    path,
    stringsAsFactors = FALSE,
    check.names = FALSE,
    colClasses = col_classes
  )

  known_levels <- vector("list", length(keep))
  names(known_levels) <- keep
  logical_vars <- character()

  for (var in keep) {
    x <- dat[[var]]
    if (is_yes_no_column(x)) {
      known_levels[[var]] <- c("no", "yes")
      logical_vars <- c(logical_vars, var)
      next
    }
    vals <- sort(unique(as.character(x[!is.na(x)])))
    known_levels[[var]] <- vals
  }

  list(
    levels = known_levels,
    logical_vars = sort(unique(logical_vars))
  )
}

build_partition_spec <- function(partition) {
  coeff_path <- file.path(results_dir, paste0(partition, "_ridge_coefficients.csv"))
  dummy_path <- file.path(results_dir, paste0(partition, "_ridge_dummy_levels.csv"))
  median_path <- file.path(results_dir, paste0(partition, "_ridge_impute_medians.csv"))
  norm_path <- file.path(results_dir, paste0(partition, "_ridge_normalize_params.csv"))
  unknown_path <- file.path(results_dir, paste0(partition, "_ridge_unknown_levels.csv"))
  novel_path <- file.path(results_dir, paste0(partition, "_ridge_novel_levels.csv"))
  train_path <- file.path(train_dir, paste0(partition, "_train.csv"))

  coefficients <- read_named_numeric(coeff_path, "term", "estimate")
  coeff_terms <- setdiff(names(coefficients), "(Intercept)")

  dummy_dat <- read.csv(dummy_path, stringsAsFactors = FALSE, check.names = FALSE)
  dummy_map <- split(dummy_dat, dummy_dat$variable)
  dummy_map <- lapply(
    dummy_map,
    function(x) {
      setNames(x$output_column, x$level)
    }
  )

  unknown_dat <- read.csv(unknown_path, stringsAsFactors = FALSE, check.names = FALSE)
  novel_dat <- read.csv(novel_path, stringsAsFactors = FALSE, check.names = FALSE)

  train_meta <- load_train_levels(train_path, names(dummy_map))

  median_all <- read_named_numeric(median_path, "term", "median")
  norm_dat <- read.csv(norm_path, stringsAsFactors = FALSE, check.names = FALSE)
  normalize_means_all <- setNames(norm_dat$mean, norm_dat$term)
  normalize_sds_all <- setNames(norm_dat$sd, norm_dat$term)

  raw_terms <- coeff_terms[!(coeff_terms %in% dummy_dat$output_column)]
  active_dummy_terms <- coeff_terms[coeff_terms %in% dummy_dat$output_column]
  active_dummy_by_var <- split(
    active_dummy_terms,
    dummy_dat$variable[match(active_dummy_terms, dummy_dat$output_column)]
  )

  list(
    coefficients = coefficients,
    raw_terms = unname(raw_terms),
    active_dummy_terms = unname(active_dummy_terms),
    active_dummy_by_var = lapply(active_dummy_by_var, unname),
    dummy_term_to_var = setNames(dummy_dat$variable, dummy_dat$output_column),
    dummy_term_to_level = setNames(dummy_dat$level, dummy_dat$output_column),
    dummy_map = dummy_map,
    known_levels = train_meta$levels,
    logical_vars = train_meta$logical_vars,
    has_unknown = setNames(
      names(dummy_map) %in% unknown_dat$variable,
      names(dummy_map)
    ),
    has_new = setNames(
      names(dummy_map) %in% novel_dat$variable,
      names(dummy_map)
    ),
    medians = median_all[coeff_terms],
    normalize_means = normalize_means_all[coeff_terms],
    normalize_sds = normalize_sds_all[coeff_terms]
  )
}

specs <- lapply(partitions, build_partition_spec)
names(specs) <- partitions

lines <- c(
  "# Generated by data-raw/build_xg_ridge_specs.R. Do not edit by hand.",
  "",
  "XG_RIDGE_MODEL_SPECS <-"
)

lines <- c(lines, capture.output(dput(specs)))
writeLines(lines, out_file, useBytes = TRUE)

message("Wrote ", out_file)
