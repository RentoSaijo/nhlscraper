# Access the shift charts for a season

`shift_charts()` loads the shift charts for a given `season`.

## Usage

``` r
shift_charts(season = 20242025)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per event (play) per game

## Examples

``` r
# May take >5s, so skip.
shift_charts_20212022 <- shift_charts(season = 20212022)
```
