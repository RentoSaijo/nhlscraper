# Access the schedule for a date

`get_schedule()` is deprecated. Use
[`schedule()`](https://rentosaijo.github.io/nhlscraper/reference/schedule.md)
instead.

## Usage

``` r
get_schedule(date = "2025-01-01")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game
