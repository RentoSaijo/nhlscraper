# Access the real-time game odds for a country by partnered bookmaker

`game_odds()` returns the public partner-game feed for one country, with
one row per current game and normalized team, game type, bookmaker, and
odds fields when NHL exposes them.

## Usage

``` r
game_odds(country = "US")
```

## Arguments

- country:

  two-letter code (e.g., 'CA'); see
  [`countries()`](https://rentosaijo.github.io/nhlscraper/reference/countries.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
game_odds_CA <- game_odds(country = 'CA')
```
