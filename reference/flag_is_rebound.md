# Flag if the shot attempt is a rebound attempt or not for all the shots in a play-by-play

`flag_is_rebound()` flags if the shot attempt is a rebound attempt or
not for all the shots in a play-by-play.

## Usage

``` r
flag_is_rebound(
  data,
  is_home_name = "isHome",
  seconds_elapsed_in_game_name = "secondsElapsedInGame",
  game_id_name = "gameId",
  sort_order_name = "sortOrder",
  type_description_name = "typeDescKey",
  is_rebound_name = "isRebound"
)
```

## Arguments

- data:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

- is_home_name:

  name of column that contains home/not logical indicator; see
  [`flag_is_home()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_home.md)
  for reference

- seconds_elapsed_in_game_name:

  name of column that contains seconds elapsed in game; see
  [`strip_time_period()`](https://rentosaijo.github.io/nhlscraper/reference/strip_time_period.md)
  for reference

- game_id_name:

  name of column that contains game ID

- sort_order_name:

  name of column that contains sort order

- type_description_name:

  name of column that contains event type description

- is_rebound_name:

  name of column that you want contain rebound/not logical indicator

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                      <- gc_play_by_play()
  test_time_period_stripped <- strip_time_period(test)
  test_is_home_flagged      <- flag_is_home(test_time_period_stripped)
  test_is_rebound_flagged   <- flag_is_rebound(test_is_home_flagged)
# }
```
