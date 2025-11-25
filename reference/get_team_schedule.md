# Access the schedule for a team and season

`get_team_schedule()` is deprecated. Use
[`team_season_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_schedule.md)
instead.

## Usage

``` r
get_team_schedule(team = "NJD", season = "now")
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

## Value

data.frame with one row per game
