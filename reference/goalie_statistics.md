# Access the career statistics for all the goalies

`goalie_statistics()` retrieves the career statistics for all the
goalies as a `data.frame` where each row represents player and includes
detail on team identity, affiliation, and matchup-side context, player
identity, role, handedness, and biographical profile, and production,
workload, efficiency, and result-level performance outcomes.

## Usage

``` r
goalie_statistics()

goalie_stats()
```

## Value

data.frame with one row per player

## Examples

``` r
goalie_stats <- goalie_statistics()
```
