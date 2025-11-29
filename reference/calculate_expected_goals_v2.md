# Calculate version 2 of the expected goals for all the events (plays) in a play-by-play

`calculate_expected_goals_v2()` calculates version 2 of the expected
goals for all the events (plays) in a play-by-play using a pre-estimated
logistic regression model of goal probability on distance, angle, empty
net, strength state, rebound, and rush indicators.

## Usage

``` r
calculate_expected_goals_v2(play_by_play)

calculate_xG_v2(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference; must be untouched by non-nhlscraper functions; saves
  time if
  [`calculate_distance()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_distance.md),
  [`calculate_angle()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_angle.md),
  [`strip_situation_code()`](https://rentosaijo.github.io/nhlscraper/reference/strip_situation_code.md),
  [`flag_is_rebound()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_rebound.md),
  and/or
  [`flag_is_rush()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_rush.md)
  have already been called

## Value

data.frame with one row per event (play) and added `xG_v2` column

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test <- gc_play_by_play()
  test <- calculate_expected_goals_v2(test)
# }
```
