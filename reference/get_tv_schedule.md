# Access the NHL Network TV schedule for a date

`get_tv_schedule()` is deprecated. Use
[`tv_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/tv_schedule.md)
instead.

## Usage

``` r
get_tv_schedule(date = "now")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per program
