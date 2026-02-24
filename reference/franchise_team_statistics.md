# Access the all-time statistics for all the franchises by team and game type

`franchise_team_statistics()` retrieves the all-time statistics for all
the franchises by team and game type as a `data.frame` where each row
represents team per franchise per game type and includes detail on
date/season filtering windows and chronological context, team identity,
affiliation, and matchup-side context, and production, workload,
efficiency, and result-level performance outcomes.

## Usage

``` r
franchise_team_statistics()

franchise_team_stats()
```

## Value

data.frame with one row per team per franchise per game type

## Examples

``` r
franchise_team_stats <- franchise_team_statistics()
```
