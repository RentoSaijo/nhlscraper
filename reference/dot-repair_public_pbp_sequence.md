# Repair public play-by-play clock/order defects in boundary-row feeds

`.repair_public_pbp_sequence()` removes rows with impossible clocks and
reorders explicit-boundary feeds into a more coherent public sequence.
The repair is intentionally scoped to the modern boundary-row era, where
the audited issues are dominated by stale sort-order markers, early
`period-end` rows, and opening faceoffs that arrive after live-play
rows.

## Usage

``` r
.repair_public_pbp_sequence(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with repaired clocks and ordering where feasible
