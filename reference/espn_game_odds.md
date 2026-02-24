# Access the ESPN odds for a game

`espn_game_odds()` retrieves the ESPN odds for a game as a `data.frame`
where each row represents provider and includes detail on team identity,
affiliation, and matchup-side context plus betting market snapshots with
side/total prices and provider variation.

## Usage

``` r
espn_game_odds(game = 401777460)
```

## Arguments

- game:

  integer ID (e.g., 401777460); see
  [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  for reference

## Value

data.frame with one row per provider

## Examples

``` r
ESPN_odds_SCF_20242025 <- espn_game_odds(game = 401777460)
```
