# Compute play-by-play deltas in R

`.compute_pbp_deltas_in_r()` is the pure-R fallback for event-to-event
delta calculations.

## Usage

``` r
.compute_pbp_deltas_in_r(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s) using the current public schema returned
  by
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)

## Value

named list containing delta context vectors
