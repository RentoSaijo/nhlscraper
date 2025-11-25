# Access the statistics for all the franchises by season and game type

`franchise_season_statistics()` scrapes the statistics for all the
franchises by season and game type.

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
