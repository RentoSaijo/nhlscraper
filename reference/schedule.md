# Access the schedule for a date

`schedule()` scrapes the schedule for a given `date`.

## Usage

``` r
schedule(date = Sys.Date())
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
schedule_Halloween_2025 <- schedule(date = '2025-10-31')
```
