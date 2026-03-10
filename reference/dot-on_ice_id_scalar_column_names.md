# List on-ice player ID columns

`.on_ice_id_scalar_column_names()` returns the public scalar goalie and
skater ID column names used in enriched play-by-play outputs.

## Usage

``` r
.on_ice_id_scalar_column_names(play_by_play = NULL, slot_count = NULL)
```

## Arguments

- play_by_play:

  optional data.frame whose existing on-ice columns should be inspected

- slot_count:

  optional integer scalar minimum slot count requested by the caller

## Value

character vector of on-ice player ID columns
