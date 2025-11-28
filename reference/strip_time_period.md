# Strip the timestamp and period number into the time elapsed in the period and game for all the events (plays) in a play-by-play

`strip_time_period()` strip the timestamp and period number into the
time elapsed in the period and game for all the events (plays) in a
play-by-play.

## Usage

``` r
strip_time_period(
  data,
  game_type_id_name = "gameTypeId",
  time_in_period_name = "timeInPeriod",
  period_number_name = "periodNumber",
  seconds_elapsed_in_period_name = "secondsElapsedInPeriod",
  seconds_elapsed_in_game_name = "secondsElapsedInGame"
)
```

## Arguments

- data:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

- game_type_id_name:

  name of column that contains game type ID; see
  [`strip_game_id()`](https://rentosaijo.github.io/nhlscraper/reference/strip_game_id.md)
  for reference

- time_in_period_name:

  name of column that contains time in period in 'MM:SS'

- period_number_name:

  name of column that contains period number

- seconds_elapsed_in_period_name:

  name of column that you want contain seconds elapsed in period

- seconds_elapsed_in_game_name:

  name of column that you want contain seconds elapsed in game

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                      <- gc_play_by_play()
  test_game_id_stripped     <- strip_game_id(test)
  test_time_period_stripped <- strip_time_period(test_game_id_stripped)
# }
```
