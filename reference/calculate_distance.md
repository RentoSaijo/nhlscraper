# Calculate the Euclidean distance from the attacking net for all the events (plays) in a play-by-play

`calculate_distance()` calculates the Euclidean distance from the
attacking net for all the events (plays) in a play-by-play.

## Usage

``` r
calculate_distance(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added `distance` column
