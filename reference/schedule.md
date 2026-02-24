# Access the schedule for a date

`schedule()` retrieves the schedule for a date as a `data.frame` where
each row represents game and includes detail on game timing, matchup
state, scoring flow, and situational event detail.

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
