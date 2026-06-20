# Access all the games

`games()` returns the stats API game catalog with one row per NHL game,
ordered by `gameId` and normalized to `gameId`, `seasonId`, and
`gameTypeId`.

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
