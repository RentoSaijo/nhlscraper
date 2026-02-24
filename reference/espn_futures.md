# Access the ESPN futures for a season

`espn_futures()` retrieves the ESPN futures for a season as a
`data.frame` where each row represents type and includes detail on
betting market snapshots with side/total prices and provider variation.

## Usage

``` r
espn_futures(season = season_now())
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

nested data.frame with one row per type (outer) and book (inner)

## Examples

``` r
ESPN_futures_20252026 <- espn_futures(20252026)
```
