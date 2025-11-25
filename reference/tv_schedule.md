# Access the NHL Network TV schedule for a date

`tv_schedule()` scrapes the NHL Network TV schedule for a given `date`.

## Usage

``` r
tv_schedule(date = "now")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per program

## Examples

``` r
tv_schedule_Halloween_2025 <- tv_schedule(date = '2025-10-31')
```
