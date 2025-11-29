# Calculate version 1 of the expected goals for all the events (plays) in a play-by-play

`calculate_expected_goals_v1()` calculates version 1 of the expected
goals for all the events (plays) in a play-by-play using a pre-estimated
logistic regression model of goal probability on distance, angle, empty
net, and strength state.

## Usage

``` r
calculate_expected_goals_v1(play_by_play)

calculate_xG_v1(play_by_play)
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
  and/or
  [`strip_situation_code()`](https://rentosaijo.github.io/nhlscraper/reference/strip_situation_code.md)
  have already been called

## Value

data.frame with one row per event (play) and added `xG_v1` column

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test <- gc_play_by_play()
  test <- calculate_expected_goals_v1(test)
# }
```
