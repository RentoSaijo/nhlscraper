# Access the standings for a date

`get_standings()` is deprecated. Use
[`standings()`](https://rentosaijo.github.io/nhlscraper/reference/standings.md)
instead.

## Usage

``` r
get_standings(date = "2025-01-01")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per team
