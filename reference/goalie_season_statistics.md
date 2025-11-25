# Access the statistics for all the goalies by season, game type, and team.

`goalie_season_statistics()` scrapes the statistics for all the goalies
by season, game type, and team.

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
