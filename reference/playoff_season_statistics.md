# Access the playoff statistics by season

`playoff_season_statistics()` retrieves the playoff statistics by season
as a `data.frame` where each row represents season and includes detail
on date/season filtering windows and chronological context.

## Usage

``` r
playoff_season_statistics()

playoff_season_stats()
```

## Value

data.frame with one row per season

## Examples

``` r
playoff_season_stats <- playoff_season_statistics()
```
