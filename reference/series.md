# Access all the playoff series by game

`series()` returns the records-site playoff-series game table with one
row per game/series entry, including season, series letter, round,
teams, and game ID fields.

## Usage

``` r
series()
```

## Value

data.frame with one row per game per series

## Examples

``` r
# May take >5s, so skip.
all_series <- series()
```
