# Access the statistics for all the franchises by season and game type

`franchise_season_statistics()` retrieves the statistics for all the
franchises by season and game type as a `data.frame` where each row
represents franchise per season per game type and includes detail on
date/season filtering windows and chronological context, team identity,
affiliation, and matchup-side context, and production, workload,
efficiency, and result-level performance outcomes.

## Usage

``` r
franchise_season_statistics()

franchise_season_stats()
```

## Value

data.frame with one row per franchise per season per game type

## Examples

``` r
# May take >5s, so skip.
franchise_season_stats <- franchise_season_statistics()
```
