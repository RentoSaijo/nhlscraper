# Access the career scoring statistics for all the goalies

`goalie_scoring()` retrieves the career scoring statistics for all the
goalies as a `data.frame` where each row represents player and includes
detail on date/season filtering windows and chronological context, team
identity, affiliation, and matchup-side context, and player identity,
role, handedness, and biographical profile.

## Usage

``` r
goalie_scoring()
```

## Value

data.frame with one row per player

## Examples

``` r
goalie_scoring <- goalie_scoring()
```
