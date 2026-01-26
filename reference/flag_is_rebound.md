# Flag if the shot attempt is a rebound attempt or creates a rebound for all the shots in a play-by-play

`flag_is_rebound()` flags whether a shot attempt is a rebound attempt
(i.e., taken within 3 seconds of a prior blocked, missed, or saved
attempt with no stoppage in between), and whether a shot attempt creates
a rebound under the same definition.

## Usage

``` r
flag_is_rebound(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added columns:
`createdRebound` and `isRebound`
