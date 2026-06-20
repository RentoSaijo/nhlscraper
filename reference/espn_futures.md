# Access the ESPN futures for a season

`espn_futures()` returns ESPN futures markets for one season with one
row per future type and nested book/odds detail retained in ESPN's
payload columns.

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
