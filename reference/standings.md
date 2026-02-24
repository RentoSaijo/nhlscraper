# Access the standings for a date

`standings()` retrieves the standings for a date as a `data.frame` where
each row represents team and includes detail on date/season filtering
windows and chronological context, production, workload, efficiency, and
result-level performance outcomes, and ranking movement, points pace,
and division/conference position signals.

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
