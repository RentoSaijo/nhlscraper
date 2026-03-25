test_that("non-base namespace usage is declared in DESCRIPTION", {
  root <- normalizePath(
    file.path(testthat::test_path(), "..", ".."),
    winslash = "/",
    mustWork = TRUE
  )
  desc <- read.dcf(file.path(root, "DESCRIPTION"))
  split_fields <- function(field) {
    if (!(field %in% colnames(desc))) {
      return(character())
    }
    parts <- trimws(unlist(strsplit(desc[1, field], ",")))
    parts <- sub("\\s*\\(.*\\)$", "", parts)
    parts[nzchar(parts)]
  }
  declared <- unique(c(
    split_fields("Depends"),
    split_fields("Imports"),
    split_fields("Suggests")
  ))
  allowed <- unique(c(
    declared,
    "base",
    "compiler",
    "datasets",
    "graphics",
    "grDevices",
    "grid",
    "methods",
    "parallel",
    "stats",
    "tools",
    "utils",
    "nhlscraper"
  ))

  source_files <- c(
    list.files(file.path(root, "R"), pattern = "\\.[Rr]$", full.names = TRUE),
    list.files(file.path(root, "tests", "testthat"), pattern = "\\.[Rr]$", full.names = TRUE),
    list.files(file.path(root, "vignettes"), pattern = "\\.Rmd$", full.names = TRUE)
  )
  namespace_pattern <- gregexpr("([A-Za-z][A-Za-z0-9.]+):::{0,2}", "", perl = TRUE)
  offenders <- character()

  for (path in source_files) {
    text <- paste(readLines(path, warn = FALSE), collapse = "\n")
    matches <- gregexpr("([A-Za-z][A-Za-z0-9.]+):::{0,2}", text, perl = TRUE)
    refs <- regmatches(text, matches)[[1]]
    if (!length(refs) || identical(refs, character(1))) {
      next
    }
    pkgs <- unique(sub(":::{0,2}$", "", refs))
    undeclared <- setdiff(pkgs, allowed)
    if (length(undeclared)) {
      offenders <- c(
        offenders,
        sprintf(
          "%s -> %s",
          basename(path),
          paste(sort(undeclared), collapse = ", ")
        )
      )
    }
  }

  expect(
    length(offenders) == 0L,
    paste(
      "Found namespace usage for packages missing from DESCRIPTION:",
      paste(offenders, collapse = "; ")
    )
  )
})
