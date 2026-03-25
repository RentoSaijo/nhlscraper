# Normalize raw/internal play-by-play names to the public schema

`.normalize_public_pbp_names()` renames the raw GameCenter/World
Showcase column names used during ingest into the current public
play-by-play schema. This helper is for the package's own ingest
pipeline only and is not a legacy-input compatibility layer for
downstream callers.

## Usage

``` r
.normalize_public_pbp_names(play_by_play)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

## Value

data.frame with current public column names where available
