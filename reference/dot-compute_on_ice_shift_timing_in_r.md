# Compute on-ice shift timings in R

`.compute_on_ice_shift_timing_in_r()` is the pure-R fallback for
resolving on-ice elapsed-shift and time-since-last-shift matrices.

## Usage

``` r
.compute_on_ice_shift_timing_in_r(play_by_play, shift_data)
```

## Arguments

- play_by_play:

  data.frame play-by-play object with on-ice player IDs

- shift_data:

  data.frame shift chart data

## Value

list containing home and away timing matrices
