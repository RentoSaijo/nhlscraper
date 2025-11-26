# Access the ESPN odds for an event (game)

`get_espn_event_odds()` is deprecated. Use
[`espn_game_odds()`](https://rentosaijo.github.io/nhlscraper/reference/espn_game_odds.md)
instead.

## Usage

``` r
get_espn_event_odds(event = 401777460)
```

## Arguments

- event:

  integer ID (e.g., 401777460); see
  [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  for reference

## Value

data.frame with one row per provider
