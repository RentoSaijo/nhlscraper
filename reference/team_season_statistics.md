# Access the statistics for all the teams by season and game type

`team_season_statistics()` retrieves the statistics for all the teams by
season and game type as a `data.frame` where each row represents team
per season per game type and includes detail on date/season filtering
windows and chronological context, team identity, affiliation, and
matchup-side context, and production, workload, efficiency, and
result-level performance outcomes.

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
