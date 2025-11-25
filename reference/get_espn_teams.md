# Get the ESPN teams for a season

`get_espn_teams()` retrieves the ESPN ID of each team for a given
`season`. Access
[`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
for `season` reference. Note the season format differs from the NHL API;
will soon be fixed to accept both. Temporarily deprecated while we
re-evaluate the practicality of ESPN API information. Use
[`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
instead.

## Usage

``` r
get_espn_teams(season = season_now()%%10000)
```

## Arguments

- season:

  integer in YYYY (e.g., 2025)

## Value

data.frame with one row per team

## Examples

``` r
ESPN_teams_20242025 <- get_espn_teams(2025)
#> Warning: `get_espn_coaches()` is temporarily deprecated. Re-evaluating the practicality of ESPN API inforamtion. Use `teams()` instead.
```
