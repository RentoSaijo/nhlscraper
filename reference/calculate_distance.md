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
  for reference; must be untouched by non-nhlscraper functions; saves
  time if
  [`normalize_coordinates()`](https://rentosaijo.github.io/nhlscraper/reference/normalize_coordinates.md)
  has already been called

## Value

data.frame with one row per event (play) and added `distance` column

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                     <- gc_play_by_play()
  test_is_home_flagged     <- flag_is_home(test)
  test_coords_normalized   <- normalize_coordinates(test_is_home_flagged)
  test_distance_calculated <- calculate_distance(test_coords_normalized)
# }
```
