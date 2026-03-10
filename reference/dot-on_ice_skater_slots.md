# Return the tracked number of on-ice skater slots

`.on_ice_skater_slots()` returns the current number of skater slots
tracked per team in play-by-play outputs. It guarantees the standard
five skater columns and expands further when the input already contains
overflow skater slots or when a caller requests a larger slot count.

## Usage

``` r
.on_ice_skater_slots(play_by_play = NULL, slot_count = NULL, min_slots = 5L)
```

## Arguments

- play_by_play:

  optional data.frame whose existing on-ice columns should be inspected

- slot_count:

  optional integer scalar minimum slot count requested by the caller

- min_slots:

  integer scalar default floor for standard outputs

## Value

integer scalar
