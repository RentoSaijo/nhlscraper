# Build scalar on-ice timing column names

`.on_ice_timing_scalar_column_names()` returns the scalar goalie and
skater timing column names for a timing metric suffix.

## Usage

``` r
.on_ice_timing_scalar_column_names(
  metric_suffix,
  play_by_play = NULL,
  slot_count = NULL
)
```

## Arguments

- metric_suffix:

  scalar timing suffix

- play_by_play:

  optional data.frame whose existing on-ice columns should be inspected

- slot_count:

  optional integer scalar minimum slot count requested by the caller

## Value

character vector of column names
