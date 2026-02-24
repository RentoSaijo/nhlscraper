# Access all the playoff series by game

`series()` retrieves all the playoff series by game as a `data.frame`
where each row represents game per series and includes detail on game
timeline state, period/clock progression, and matchup flow, date/season
filtering windows and chronological context, and playoff-series
progression, round status, and series leverage.

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
