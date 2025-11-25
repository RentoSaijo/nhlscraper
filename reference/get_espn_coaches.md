# Get the ESPN coaches for a season

`get_espn_coaches()` retrieves the ESPN ID of each coach for a given
`season`. Access
[`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
for `season` reference. Note the season format differs from the NHL API;
will soon be fixed to accept both. Temporarily deprecated while we
re-evaluate the practicality of ESPN API information. Use
[`coaches()`](https://rentosaijo.github.io/nhlscraper/reference/coaches.md)
instead.

## Usage

``` r
get_espn_coaches(season = season_now()%%10000)
```

## Arguments

- season:

  integer in YYYY (e.g., 2025)

## Value

data.frame with one row per coach

## Examples

``` r
ESPN_coaches_20242025 <- get_espn_coaches(2025)
#> Warning: `get_espn_coaches()` is temporarily deprecated. Re-evaluating the practicality of ESPN API inforamtion. Use `coaches()` instead.
```
