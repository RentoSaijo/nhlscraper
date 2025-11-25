# Access the playoff statistics for all the skaters by series

`skater_series_statistics()` scrapes the playoff statistics for all the
skaters by series.

## Usage

``` r
skater_series_statistics()

skater_series_stats()
```

## Value

data.frame with one row per player per series

## Examples

``` r
# May take >5s, so skip.
skater_series_stats <- skater_series_statistics()
```
