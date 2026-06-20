# Access the schedule for a date

`schedule()` returns the public schedule rows for one date, including
game IDs, teams, start/status, scores, venue, broadcasts, and links.

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
