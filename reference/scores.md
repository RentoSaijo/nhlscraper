# Access the scores for a date

`scores()` scrapes the scores for a given `date`.

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
