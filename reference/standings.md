# Access the standings for a date

`standings()` returns public standings for one date with one row per
team, including rank, record, points, streak, division/conference, and
normalized team fields.

## Usage

``` r
standings(date = "now")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per team

## Examples

``` r
standings_Halloween_2025 <- standings(date = '2025-10-31')
```
