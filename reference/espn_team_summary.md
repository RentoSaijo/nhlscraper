# Access the ESPN summary for a team

`espn_team_summary()` retrieves the ESPN summary for a team as a
`data.frame` where each row represents one result and includes detail on
game timing, matchup state, scoring flow, and situational event detail.

## Usage

``` r
espn_team_summary(team = 1)
```

## Arguments

- team:

  integer ID (e.g., 1); see
  [`espn_teams()`](https://rentosaijo.github.io/nhlscraper/reference/espn_teams.md)
  for reference

## Value

data.frame with one row

## Examples

``` r
ESPN_summary_Boston_Bruins <- espn_team_summary(team = 1)
```
