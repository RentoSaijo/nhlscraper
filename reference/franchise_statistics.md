# Access the all-time statistics for all the franchises by game type

`franchise_statistics()` retrieves the all-time statistics for all the
franchises by game type as a `data.frame` where each row represents
franchise per game type and includes detail on date/season filtering
windows and chronological context, team identity, affiliation, and
matchup-side context, and production, workload, efficiency, and
result-level performance outcomes.

## Usage

``` r
franchise_statistics()

franchise_stats()
```

## Value

data.frame with one row per franchise per game type

## Examples

``` r
franchise_stats <- franchise_statistics()
```
