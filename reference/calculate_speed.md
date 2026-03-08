# Calculate event-to-event deltas and speeds in normalized x/y, distance, and angle for a play-by-play

`calculate_speed()` calculates event-to-event deltas and speeds in
normalized x/y, distance, and angle for a play-by-play. Sequences are
bounded by faceoffs: each sequence begins at a faceoff, faceoff rows do
not look backward across the boundary, and subsequent events are
compared to the most recent prior valid-spatial event in the same
faceoff-bounded sequence. Shootout and penalty-shot rows (`0101`/`1010`)
are left as `NA` and do not serve as anchors for later rows. When
multiple events in a sequence share the same recorded second, zero-time
denominators are replaced by `1 / n`, where `n` is the number of events
in that same second within the sequence.

## Usage

``` r
calculate_speed(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)
  for reference; the original columns must exist

## Value

data.frame with one row per event (play) and added columns: `dXN`,
`dYN`, `dD`, `dA`, `dT`, `dXNdT`, `dYNdT`, `dDdT`, `dAdT`,
`eventIdPrev`, `secondsElapsedInSequence`
