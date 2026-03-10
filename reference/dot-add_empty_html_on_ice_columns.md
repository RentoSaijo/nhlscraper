# Initialize empty on-ice columns

`.add_empty_html_on_ice_columns()` allocates empty scalar on-ice player
ID and timing columns before HTML and shift-chart enrichment.

## Usage

``` r
.add_empty_html_on_ice_columns(play_by_play, slot_count = NULL)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- slot_count:

  optional integer scalar minimum slot count requested by the caller

## Value

data.frame with empty on-ice columns added
