# Access the scores for a date

`scores()` returns the public scoreboard for one date with one row per
game, including team abbreviations, start/status fields, score state,
venue, broadcasts, and game links when the API exposes them.

## Usage

``` r
scores(date = "now")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
scores_Halloween_2025 <- scores(date = '2025-10-31')
```
