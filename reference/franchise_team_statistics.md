# Access the all-time statistics for all the franchises by team and game type

`franchise_team_statistics()` returns all-time totals by franchise-era
team and game type, preserving separate rows for teams that share a
franchise.

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
