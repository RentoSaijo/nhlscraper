# Access the statistics for all the skaters by season, game type, and team

`skater_season_statistics()` retrieves the statistics for all the
skaters by season, game type, and team as a `data.frame` where each row
represents player per season per game type, separated by team if
applicable and includes detail on date/season filtering windows and
chronological context, team identity, affiliation, and matchup-side
context, and player identity, role, handedness, and biographical
profile.

## Usage

``` r
skater_season_statistics()

skater_season_stats()
```

## Value

data.frame with one row per player per season per game type, separated
by team if applicable

## Examples

``` r
# May take >5s, so skip.
skater_season_stats <- skater_season_statistics()
```
