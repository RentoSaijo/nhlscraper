# Access the statistics for all the coaches by franchise and game type

`coach_franchise_statistics()` returns coach records by franchise and
game type, with one row per coach/franchise/game-type stint.

## Usage

``` r
coach_franchise_statistics()

coach_franchise_stats()
```

## Value

data.frame with one row per franchise per coach per game type

## Examples

``` r
coach_franchise_stats <- coach_franchise_statistics()
```
