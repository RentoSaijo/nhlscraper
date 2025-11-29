# Flag if the shot attempt is a rush attempt or not for all the shots in a play-by-play

`flag_is_rush()` flags if the shot attempt is a rush attempt or not for
all the shots in a play-by-play.

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
  for reference; must be untouched by non-nhlscraper functions; saves
  time if
  [`flag_is_home()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_home.md)
  and
  [`strip_time_period()`](https://rentosaijo.github.io/nhlscraper/reference/strip_time_period.md)
  had already been called

## Value

data.frame with one row per event (play) and added `isRush` column

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                      <- gc_play_by_play()
  test_is_home_flagged      <- flag_is_home(test)
  test_game_id_stripped     <- strip_game_id(test_is_home_flagged)
  test_time_period_stripped <- strip_time_period(test_game_id_stripped)
  test_is_rush_flagged      <- flag_is_rush(test_time_period_stripped)
# }
```
