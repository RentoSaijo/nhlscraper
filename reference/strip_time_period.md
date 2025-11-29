# Strip the timestamp and period number into the time elapsed in the period and game for all the events (plays) in a play-by-play

`strip_time_period()` strip the timestamp and period number into the
time elapsed in the period and game for all the events (plays) in a
play-by-play.

## Usage

``` r
strip_time_period(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference; must be untouched by non-nhlscraper functions; saves
  time if
  [`strip_game_id()`](https://rentosaijo.github.io/nhlscraper/reference/strip_game_id.md)
  has already been called

## Value

data.frame with one row per event (play) and added columns
`secondsElapsedInPeriod` and `secondsElapsedInGame`

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                      <- gc_play_by_play()
  test_game_id_stripped     <- strip_game_id(test)
  test_time_period_stripped <- strip_time_period(test_game_id_stripped)
# }
```
