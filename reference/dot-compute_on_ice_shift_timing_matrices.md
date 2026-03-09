# Compute on-ice shift timing matrices

`.compute_on_ice_shift_timing_matrices()` uses the native timing
resolver when available and falls back to the R implementation
otherwise.

## Usage

``` r
.compute_on_ice_shift_timing_matrices(play_by_play, shift_data)
```

## Arguments

- play_by_play:

  data.frame play-by-play object with on-ice player IDs

- shift_data:

  data.frame shift chart data

## Value

list containing home and away timing matrices
