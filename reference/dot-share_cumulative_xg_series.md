# Build cumulative xG series

`.share_cumulative_xg_series()` converts shot-attempt rows into home and
away step-series vectors.

## Usage

``` r
.share_cumulative_xg_series(shots, play_by_play)
```

## Arguments

- shots:

  data.frame of shot-attempt rows

- play_by_play:

  full game play-by-play

## Value

named list of cumulative xG series
