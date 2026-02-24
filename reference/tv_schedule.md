# Access the NHL Network TV schedule for a date

`tv_schedule()` retrieves the NHL Network TV schedule for a date as a
`data.frame` where each row represents program and includes detail on
date/season filtering windows and chronological context.

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
