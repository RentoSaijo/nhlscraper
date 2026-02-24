# Access the career regular season statistics for all the goalies

`goalie_regular_statistics()` retrieves the career regular season
statistics for all the goalies as a `data.frame` where each row
represents goalie and includes detail on date/season filtering windows
and chronological context, team identity, affiliation, and matchup-side
context, and player identity, role, handedness, and biographical
profile.

## Usage

``` r
goalie_regular_statistics()

goalie_regular_stats()
```

## Value

data.frame with one row per goalie

## Examples

``` r
goalie_career_regular_statistics <- goalie_regular_statistics()
```
