# Access the career statistics for all the skaters

`skater_statistics()` retrieves the career statistics for all the
skaters as a `data.frame` where each row represents player and includes
detail on player identity, role, handedness, and biographical profile
plus production, workload, efficiency, and result-level performance
outcomes.

## Usage

``` r
skater_statistics()

skater_stats()
```

## Value

data.frame with one row per player

## Examples

``` r
skater_stats <- skater_statistics()
```
