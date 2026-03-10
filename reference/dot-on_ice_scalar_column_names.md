# List all scalar on-ice columns

`.on_ice_scalar_column_names()` returns the scalar on-ice player ID and
shift-timing columns used by the public play-by-play schema.

## Usage

``` r
.on_ice_scalar_column_names(play_by_play = NULL, slot_count = NULL)
```

## Arguments

- play_by_play:

  optional data.frame whose existing on-ice columns should be inspected

- slot_count:

  optional integer scalar minimum slot count requested by the caller

## Value

character vector of scalar on-ice columns
