# Validate required public play-by-play columns

`.require_public_pbp_columns()` errors when a public helper is called
with a play-by-play missing required public schema columns.

## Usage

``` r
.require_public_pbp_columns(play_by_play, cols, fn_name)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- cols:

  character vector of required columns

- fn_name:

  calling function name used in the error message

## Value

`NULL`, invisibly, or an error if required columns are missing
