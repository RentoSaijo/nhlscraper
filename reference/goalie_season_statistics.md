# Access the statistics for all the goalies by season, game type, and team.

`goalie_season_statistics()` retrieves the statistics for all the
goalies by season, game type, and team as a `data.frame` where each row
represents player per season per game type, separated by team if
applicable and includes detail on date/season filtering windows and
chronological context, team identity, affiliation, and matchup-side
context, and player identity, role, handedness, and biographical
profile.

## Usage

``` r
goalie_season_statistics()

goalie_season_stats()
```

## Value

data.frame with one row per player per season per game type, separated
by team if applicable

## Examples

``` r
goalie_season_stats <- goalie_season_statistics()
```
