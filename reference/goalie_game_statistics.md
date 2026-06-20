# Access the statistics for all the goalies by game

`goalie_game_statistics()` returns records-site goalie stat rows by
player and game, including opponent fields and normalized team
abbreviations.

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
