# Access the prospects for a team and position

`get_team_prospects()` is deprecated. Use
[`team_prospects()`](https://rentosaijo.github.io/nhlscraper/reference/team_prospects.md)
instead.

## Usage

``` r
get_team_prospects(team = "NJD", player_type = "forwards")
```

## Arguments

- team:

  three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference

- player_type:

  character of 'forwards', 'defensemen', or 'goalies'

## Value

data.frame with one row per player
