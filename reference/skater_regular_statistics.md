# Access the career regular season statistics for all the skaters

`skater_regular_statistics()` retrieves the career regular season
statistics for all the skaters as a `data.frame` where each row
represents player and includes detail on team identity, affiliation, and
matchup-side context, player identity, role, handedness, and
biographical profile, and production, workload, efficiency, and
result-level performance outcomes.

## Usage

``` r
skater_regular_statistics()

skater_regular_stats()
```

## Value

data.frame with one row per player

## Examples

``` r
skater_regular_stats <- skater_regular_statistics()
```
