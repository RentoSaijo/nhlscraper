# Access the ESPN summary for a game

`espn_game_summary()` returns ESPN's competition summary for one game
after dropping large availability/link/detail blocks, leaving the
compact game, competitor, venue, date, format, and series fields exposed
by the core API.

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
