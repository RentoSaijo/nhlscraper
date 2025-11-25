# Access the statistics for all the skaters by season, game type, and team

`skater_season_statistics()` scrapes the statistics for all the skaters
by season, game type, and team.

## Usage

``` r
skater_season_statistics()

skater_season_stats()
```

## Value

data.frame with one row per player per season per game type, separated
by team if applicable

## Examples

``` r
# May take >5s, so skip.
skater_season_stats <- skater_season_statistics()
```
