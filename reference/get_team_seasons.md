# Access the season(s) and game type(s) in which a team played

`get_team_seasons()` is deprecated. Use
[`team_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_seasons.md)
instead.

## Usage

``` r
get_team_seasons(team = "NJD")
```

## Arguments

- team:

  three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference

## Value

data.frame with one row per season
