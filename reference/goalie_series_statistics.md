# Access the playoff statistics for all the goalies by series

`goalie_series_statistics()` retrieves the playoff statistics for all
the goalies by series as a `data.frame` where each row represents player
per series and includes detail on date/season filtering windows and
chronological context, team identity, affiliation, and matchup-side
context, and player identity, role, handedness, and biographical
profile.

## Usage

``` r
goalie_series_statistics()

goalie_series_stats()
```

## Value

data.frame with one row per player per series

## Examples

``` r
goalie_series_stats <- goalie_series_statistics()
```
