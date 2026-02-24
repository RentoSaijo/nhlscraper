# Access the playoff statistics for all the skaters by series

`skater_series_statistics()` retrieves the playoff statistics for all
the skaters by series as a `data.frame` where each row represents player
per series and includes detail on date/season filtering windows and
chronological context, team identity, affiliation, and matchup-side
context, and player identity, role, handedness, and biographical
profile.

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
