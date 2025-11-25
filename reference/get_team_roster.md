# Access the roster for a team, season, and player type

`get_team_roster()` is deprecated. Use
[`roster()`](https://rentosaijo.github.io/nhlscraper/reference/roster.md)
instead.

## Usage

``` r
get_team_roster(team = "NJD", season = "current", player_type = "forwards")
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

- player_type:

  character of 'forwards', 'defensemen', or 'goalies'

## Value

data.frame with one row per player
