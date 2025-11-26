# Access the ESPN summary for a team

`espn_team_summary()` scrapes the ESPN summary for a `team`.

## Usage

``` r
espn_team_summary(team = 3988803)
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
