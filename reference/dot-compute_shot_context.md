# Compute shot context summaries

`.compute_shot_context()` derives rush and rebound flags plus running
goal, shot, Fenwick, and Corsi counts, using native code when available.

## Usage

``` r
.compute_shot_context(play_by_play)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

## Value

named list of logical and integer shot-context vectors
