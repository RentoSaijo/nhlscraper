# Access the statistics for all the coaches by franchise and game type

`coach_franchise_statistics()` retrieves the statistics for all the
coaches by franchise and game type as a `data.frame` where each row
represents franchise per coach per game type and includes detail on
date/season filtering windows and chronological context, team identity,
affiliation, and matchup-side context, and player identity, role,
handedness, and biographical profile.

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
