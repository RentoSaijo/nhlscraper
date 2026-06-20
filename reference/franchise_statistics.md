# Access the all-time statistics for all the franchises by game type

`franchise_statistics()` returns all-time franchise totals by game type,
including games, wins/losses, goals, points, and related aggregate
fields.

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
