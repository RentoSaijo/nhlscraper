# Access the roster statistics for a team, season, game type, and player type

`get_team_roster_statistics()` is deprecated. Use
[`roster_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/roster_statistics.md)
instead.

## Usage

``` r
get_team_roster_statistics(
  team = "NJD",
  season = "now",
  game_type = 2,
  player_type = "skaters"
)
```

## Arguments

- team:

  three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  playoff'/'post'; see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference; most functions will NOT support pre-season

- player_type:

  character of 'skaters' or 'goalies'

## Value

data.frame with one row per player
