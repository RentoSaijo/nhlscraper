# Access the shift chart summaries for a season

`shift_chart_summaries()` downloads the stored season-level
shift-summary parquet snapshot with per-player, per-period time-on-ice
splits.

## Usage

``` r
shift_chart_summaries(season = 20242025)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per player per period

## Examples

``` r
# May take >5s, so skip.
shift_chart_summaries_20212022 <- shift_chart_summaries(season = 20212022)
```
