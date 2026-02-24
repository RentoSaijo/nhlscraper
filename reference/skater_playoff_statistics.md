# Access the career playoff statistics for all the skaters

`skater_playoff_statistics()` retrieves the career playoff statistics
for all the skaters as a `data.frame` where each row represents player
and includes detail on team identity, affiliation, and matchup-side
context, player identity, role, handedness, and biographical profile,
and production, workload, efficiency, and result-level performance
outcomes.

## Usage

``` r
skater_playoff_statistics()

skater_playoff_stats()
```

## Value

data.frame with one row per player

## Examples

``` r
skater_playoff_stats <- skater_playoff_statistics()
```
