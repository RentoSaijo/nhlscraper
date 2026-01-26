# Flag if the shot attempt is a rush attempt or not for all the shots in a play-by-play

`flag_is_rush()` flags whether a shot attempt is a rush attempt, defined
as any shot attempt occurring within 4 seconds of a prior event in the
neutral or defensive zone with no stoppage in play in between.

## Usage

``` r
flag_is_rush(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added `isRush` column
