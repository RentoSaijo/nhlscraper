# Access all the games

`games()` retrieves all the games as a `data.frame` where each row
represents game and includes detail on game timeline state, period/clock
progression, and matchup flow plus date/season filtering windows and
chronological context.

## Usage

``` r
games()
```

## Value

data.frame with one row per game

## Examples

``` r
# May take >5s, so skip.
all_games <- games()
```
