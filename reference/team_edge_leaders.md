# Access the team EDGE statistics leaders for a season and game type

`team_edge_leaders()` scrapes the team EDGE statistics leaders for a
given set of `season` and `game_type`.

## Usage

``` r
team_edge_leaders(season = "now", game_type = "")
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`team_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  'playoff'/'post'; see
  [`team_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_seasons.md)
  for reference; most functions will NOT support pre-season

## Value

list of various items

## Examples

``` r
team_EDGE_leaders_regular_20242025 <- team_edge_leaders(
  season    = 20242025,
  game_type = 2
)
```
