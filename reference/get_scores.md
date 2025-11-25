# Access the scores for a date

`get_scores()` is deprecated. Use
[`scores()`](https://rentosaijo.github.io/nhlscraper/reference/scores.md)
instead.

## Usage

``` r
get_scores(date = "now")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game
