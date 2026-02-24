# Access the ESPN summary for a game

`espn_game_summary()` retrieves the ESPN summary for a game as a nested
`list` that separates summary and detail blocks for date/season
filtering windows and chronological context, venue/location geography
and regional metadata, and playoff-series progression, round status, and
series leverage.

## Usage

``` r
espn_game_summary(game = 401777460)
```

## Arguments

- game:

  integer ID (e.g., 401777460); see
  [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  for reference

## Value

list with various items

## Examples

``` r
ESPN_summary_SCF_20242025 <- espn_game_summary(game = 401777460)
```
