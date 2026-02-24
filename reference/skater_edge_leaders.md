# Access the skater EDGE statistics leaders for a season and game type

`skater_edge_leaders()` retrieves the skater EDGE statistics leaders for
a season and game type as a nested `list` that separates summary and
detail blocks for NHL EDGE style tracking outputs and
relative-performance context.

## Usage

``` r
skater_edge_leaders(season = "now", game_type = "")
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`skater_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  'playoff'/'post'; see
  [`skater_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_seasons.md)
  for reference; most functions will NOT support pre-season

## Value

list of various items

## Examples

``` r
skater_EDGE_leaders_regular_20242025 <- skater_edge_leaders(
  season    = 20242025,
  game_type = 2
)
```
