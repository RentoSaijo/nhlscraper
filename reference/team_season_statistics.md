# Access the statistics for all the teams by season and game type

`team_season_statistics()` returns records-site team totals by team,
season, and game type, including win/loss, goal, shot, standings-point,
and related season-total fields.

## Usage

``` r
team_season_statistics()

team_season_stats()
```

## Value

data.frame with one row per team per season per game type

## Examples

``` r
# May take >5s, so skip.
team_season_statistics <- team_season_statistics()
```
