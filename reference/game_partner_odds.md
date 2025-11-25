# Get the real-time game odds for a country by partnered bookmaker

`game_partner_odds()` scrapes the real-time game odds for a given
`country` by partnered bookmaker.

## Usage

``` r
game_partner_odds(country = "US")
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
game_partner_odds_CA <- game_partner_odds(country = 'CA')
```
