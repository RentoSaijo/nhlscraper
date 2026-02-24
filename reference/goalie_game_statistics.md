# Access the statistics for all the goalies by game

`goalie_game_statistics()` retrieves the statistics for all the goalies
by game as a `data.frame` with detail on game timeline state,
period/clock progression, and matchup flow, date/season filtering
windows and chronological context, and team identity, affiliation, and
matchup-side context.

## Usage

``` r
goalie_game_statistics()

goalie_game_stats()
```

## Value

data.frame with one row per goalie per game

## Examples

``` r
goalie_game_stats <- goalie_game_statistics()
```
