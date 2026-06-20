# Access the statistics for all the skaters by season, game type, and team

`skater_season_statistics()` returns records-site player stat rows by
player, team, season, and game type, preserving separate rows when a
player changed teams.

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
