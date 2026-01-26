# Flag if the event belongs to the home team or not for all the events (plays) in a play-by-play

`flag_is_home()` flags if the event belongs to the home team or not for
all the events (plays) in a play-by-play.

## Usage

``` r
flag_is_home(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added `isHome` column
