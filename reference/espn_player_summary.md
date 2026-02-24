# Access the ESPN summary for a player

`espn_player_summary()` retrieves the ESPN summary for a player as a
`data.frame` where each row represents one result and includes detail on
game timing, matchup state, scoring flow, and situational event detail.

## Usage

``` r
espn_player_summary(player = 3988803)
```

## Arguments

- player:

  integer ID (e.g., 3988803); see
  [`espn_players()`](https://rentosaijo.github.io/nhlscraper/reference/espn_players.md)
  for reference

## Value

data.frame with one row

## Examples

``` r
ESPN_summary_Charlie_McAvoy <- espn_player_summary(player = 3988803)
```
