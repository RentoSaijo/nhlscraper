# Access all the ESPN players

`espn_players()` pages ESPN's athlete index and returns one row per
athlete containing the ESPN player ID used by
[`espn_player_summary()`](https://rentosaijo.github.io/nhlscraper/reference/espn_player_summary.md).

## Usage

``` r
espn_players()
```

## Value

data.frame with one row per ESPN player

## Examples

``` r
all_ESPN_players <- espn_players()
```
