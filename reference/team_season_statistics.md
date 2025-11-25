# Access the statistics for all the teams by season and game type

`team_season_statistics()` scrapes the statistics for all the teams by
season and game type.

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
