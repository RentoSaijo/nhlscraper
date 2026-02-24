# Access the real-time game odds for a country by partnered bookmaker

`game_odds()` retrieves the real-time game odds for a country by
partnered bookmaker as a `data.frame` where each row represents game and
includes detail on betting market lines, prices, and provider-level
context.

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
