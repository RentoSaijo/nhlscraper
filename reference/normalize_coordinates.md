# Normalize the x and y coordinates for all the events (plays) in a play-by-play

`normalize_coordinates()` normalizes the x and y coordinates for all the
events (plays) in a play-by-play such that they all attack towards +x.

## Usage

``` r
normalize_coordinates(
  data,
  is_home_name = "isHome",
  home_team_defending_side_name = "homeTeamDefendingSide",
  x_coordinate_name = "xCoord",
  y_coordinate_name = "yCoord",
  x_coordinate_normalized_name = "xCoordNorm",
  y_coordinate_normalized_name = "yCoordNorm"
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

- home_team_defending_side_name:

  name of column that contains home team defending side

- x_coordinate_name:

  name of column that contains x coordinate

- y_coordinate_name:

  name of column that contains y coordinate

- x_coordinate_normalized_name:

  name of column that you want contain normalized x coordinate

- y_coordinate_normalized_name:

  name of column that you want contain normalized y coordinate

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                   <- gc_play_by_play()
  test_is_home_flagged   <- flag_is_home(test)
  test_coords_normalized <- normalize_coordinates(test_is_home_flagged)
# }
```
