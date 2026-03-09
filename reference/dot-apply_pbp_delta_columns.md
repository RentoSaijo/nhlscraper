# Attach delta context columns to play-by-play

`.apply_pbp_delta_columns()` inserts computed delta columns into a
play-by-play and reorders them into the public schema.

## Usage

``` r
.apply_pbp_delta_columns(play_by_play, delta_ctx)
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

- delta_ctx:

  named list returned by
  [`.compute_pbp_deltas()`](https://rentosaijo.github.io/nhlscraper/reference/dot-compute_pbp_deltas.md)

## Value

data.frame with public delta columns inserted
