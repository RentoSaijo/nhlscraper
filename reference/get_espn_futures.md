# Get the ESPN futures for a season

`get_espn_futures()` retrieves real-time ESPN futures of various types
for a given `season`. Access
[`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
for `season` reference. Note the season format differs from the NHL API;
will soon be fixed to accept both.

## Usage

``` r
get_espn_futures(season = season_now()%%10000)
```

## Arguments

- season:

  integer in YYYY (e.g., 2026)

## Value

nested data.frame with one row per type (outer) and book (inner)

## Examples

``` r
ESPN_futures_20252026 <- get_espn_futures(2026)
```
